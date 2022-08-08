
import 'package:flutter_client/tools/observable.dart';
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

  static void clearCaller(){
    callerRoomId.value = "";
  }

  static bool isSomeoneCalling(){
    return callerRoomId.value != "";
  }

  static acceptCall(){

  }
}