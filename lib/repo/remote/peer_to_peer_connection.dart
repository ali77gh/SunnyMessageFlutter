import 'dart:convert';

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
      WebSocketService.publish(ChatViewModel.contact.value!.roomId, candidate.toMap());
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

    print('Create PeerConnection with configuration: $configuration');
    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // send ICE
    peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      print('onIceCandidate: ${candidate.toMap()}');
      WebSocketService.publish(ChatViewModel.contact.value!.roomId, candidate.toMap());
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
    offerBuffer = null;
  }

  static onICEReceive(Map<String,dynamic> data){
    print('Got new remote ICE candidate: ${jsonEncode(data)}');
    peerConnection!.addCandidate(
      RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      ),
    );
  }

  static Map<String,dynamic>? offerBuffer;
  static onOfferReceive(Map<String, dynamic> data){
    offerBuffer = data;
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
      }
  }

  static Future<void> openUserMedia() async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': false}); // TODO check this if sound not working

    await Future.delayed(const Duration(milliseconds: 1000));
    VideoCallViewModel.localRenderer!.srcObject = stream;
    localStream = stream;

    VideoCallViewModel.remoteRenderer!.srcObject = await createLocalMediaStream('key');

    await Future.delayed(const Duration(milliseconds: 1000));
    VideoCallViewModel.localRenderer!.notifyListeners();
  }

  static Future<void> hangUp() async {
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
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      VideoCallViewModel.localRenderer!.srcObject = stream;
      remoteStream = stream;
    };
  }
}
