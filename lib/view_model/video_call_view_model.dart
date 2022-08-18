
import 'package:flutter_client/repo/remote/peer_to_peer_connection.dart';
import 'package:flutter_client/tools/observable.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum CallState{
  NormalTextChat,
  JustLocalCamera,
  Calling,
  InCall
}

class VideoCallViewModel{

  static var state = Observable<CallState>(CallState.NormalTextChat);

  static RTCVideoRenderer? localRenderer;
  static RTCVideoRenderer? remoteRenderer;
  
  // someone is calling
  static var callerRoomId = Observable("");

  static String callerName(){
    for(var contact in ContactViewModel.contacts.value){
      if(contact.roomId==callerRoomId.value) return contact.name;
    }
    return "Unknown";
  }

  static onCallComes(String roomId){
    callerRoomId.value = roomId;
  }

  static bool isSomeoneCalling(){
    return callerRoomId.value != "";
  }

  static void reject(){
    callerRoomId.value = "";
  }

  static acceptCall(){
    for(var contact in ContactViewModel.contacts.value){
      if(contact.roomId==callerRoomId.value){
        ChatViewModel.contact.value = contact;
        PeerToPeerConnection.answer();
        VideoCallViewModel.state.value = CallState.InCall;
        callerRoomId.value = "";
        return;
      }
    }
    print("Not Found");
  }
}