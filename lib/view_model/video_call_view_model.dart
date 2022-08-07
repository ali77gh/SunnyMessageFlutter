
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
}