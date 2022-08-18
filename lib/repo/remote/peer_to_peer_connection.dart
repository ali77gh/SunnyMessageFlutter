
import 'package:flutter_client/repo/remote/web_socket_service.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';
import 'package:flutter_client/view_model/video_call_view_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerToPeerConnection{

  static Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  static RTCPeerConnection? peerConnection;
  static MediaStream? localStream;
  static MediaStream? remoteStream;

  static Future<void> call() async {

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // send ICE
    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('Got candidate: ${candidate.toMap()}');
      WebSocketService.publishICE(ChatViewModel.contact.value!.roomId, candidate.toMap());
    };

    // send Offer
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    print('Created offer: $offer');
    Map<String, dynamic> roomWithOffer = { 'offer': offer.toMap() };
    WebSocketService.publishOffer(ChatViewModel.contact.value!.roomId, roomWithOffer);

    // on track receive
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };
  }

  static answer() async {

    await openUserMedia();
    print('Create PeerConnection with configuration: $configuration');
    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // send ICE
    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      print('onIceCandidate: ${candidate.toMap()}');
      WebSocketService.publishICE(ChatViewModel.contact.value!.roomId, candidate.toMap());
    };


    // on track receive
    peerConnection?.onTrack = (RTCTrackEvent event) {
      print('Got remote track: ${event.streams[0]}');
      event.streams[0].getTracks().forEach((track) {
        print('Add a track to the remoteStream: $track');
        remoteStream?.addTrack(track);
      });
    };

    // send answer
    var offer = offerBuffer!['offer'];
    await peerConnection?.setRemoteDescription(
      RTCSessionDescription(offer['sdp'], offer['type']),
    );
    var answer = await peerConnection!.createAnswer();
    print('Created Answer $answer');

    await peerConnection!.setLocalDescription(answer);

    Map<String, dynamic> roomWithAnswer = {
      'answer': { 'type': answer.type, 'sdp': answer.sdp }
    };
    WebSocketService.publishAnswer(ChatViewModel.contact.value!.roomId, roomWithAnswer);

    // add remote canicdates
    for(var ice in remoteICEs){
      peerConnection!.addCandidate(
        RTCIceCandidate(
          ice['candidate'],
          ice['sdpMid'],
          ice['sdpMLineIndex'],
        ),
      );
    }

    offerBuffer = null;
    remoteICEs.clear();
  }

  static List<Map<String,dynamic>> remoteICEs = [];
  static onICEReceive(Map<String,dynamic> data){
    remoteICEs.add(data);
  }

  static Map<String,dynamic>? offerBuffer;
  static onOfferReceive(String roomId, Map<String, dynamic> data){
    offerBuffer = data;
    VideoCallViewModel.onCallComes(roomId);
  }

  static onAnswerReceive(Map<String, dynamic> data) async {

      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        print("Someone tried to connect");
        await peerConnection?.setRemoteDescription(answer);
        VideoCallViewModel.state.value = CallState.InCall;

      }
  }

  static Future<void> openUserMedia() async {

    if(localStream!=null) return;

    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': false }); // TODO check this if sound not working

    await Future.delayed(const Duration(milliseconds: 1000));
    VideoCallViewModel.localRenderer!.srcObject = stream;
    localStream = stream;

    // await Future.delayed(const Duration(milliseconds: 15000));
    // VideoCallViewModel.remoteRenderer!.srcObject = await createLocalMediaStream('key');

    // VideoCallViewModel.localRenderer!.notifyListeners();
  }

  static Future<void> hangUp() async {

    // send hangup signal
    VideoCallViewModel.localRenderer!.srcObject!.getTracks()
        .forEach((track) {
      track.stop();
    });

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    localStream!.dispose();
    remoteStream?.dispose();
  }

  static void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
      if(state==RTCPeerConnectionState.RTCPeerConnectionStateClosed){
        VideoCallViewModel.state.value = CallState.NormalTextChat;
      }
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      VideoCallViewModel.remoteRenderer!.srcObject = stream;
    };
  }
}
