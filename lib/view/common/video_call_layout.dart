
import 'package:flutter/material.dart';
import 'package:flutter_client/repo/remote/peer_to_peer_connection.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/app_theme.dart';
import 'package:flutter_client/view_model/video_call_view_model.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoChatLayout extends StatefulWidget {
  @override
  State<VideoChatLayout> createState() => VideoChatLayoutState ();
}

class VideoChatLayoutState extends State<VideoChatLayout> {

  VideoChatLayoutState(){
    VideoCallViewModel.state.subscribe((){ setState(() { }); });
  }

  @override
  Widget build(BuildContext context) {
    var children = [
      Expanded(
        child: RTCVideoView(VideoCallViewModel.localRenderer!, mirror: true) ,
      ),
      Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                color: AppTheme.text_sharp,
                child: RTCVideoView(VideoCallViewModel.remoteRenderer!)
            ),
            if(VideoCallViewModel.state.value == CallState.Calling) const Text("Calling...",style: TextStyle(color: AppTheme.background_2),)
          ],
        ) ,
      ),
      Container(
          padding: const EdgeInsets.all(20),
          color: AppTheme.primary,
          child: GestureDetector(
            child: Image.asset(
              (
                  VideoCallViewModel.state.value == CallState.InCall ||
                      VideoCallViewModel.state.value == CallState.Calling
              ) ? "assets/hangup.png" : "assets/call.png",
              width: AppSizes.fontLarge,
              height: AppSizes.fontLarge,
            ),
            onTap: (){
              if(
              VideoCallViewModel.state.value == CallState.InCall ||
                  VideoCallViewModel.state.value == CallState.Calling
              ) {
                VideoCallViewModel.state.value = CallState.NormalTextChat;
                PeerToPeerConnection.hangUp();
              }else if(VideoCallViewModel.state.value == CallState.JustLocalCamera){
                VideoCallViewModel.state.value = CallState.Calling;
                //TODO make connection and get stream
              }
            },
          )
      ),
    ];

    return AppSizes.isMobile ? Column(children: children,) : Row(children: children,);
  }

  @override
  void initState() {
    VideoCallViewModel.localRenderer = RTCVideoRenderer();
    VideoCallViewModel.remoteRenderer = RTCVideoRenderer();
    VideoCallViewModel.localRenderer!.initialize();
    VideoCallViewModel.remoteRenderer!.initialize();

    super.initState();
  }

  @override
  void dispose() {
    PeerToPeerConnection.hangUp();
    VideoCallViewModel.localRenderer!.dispose();
    VideoCallViewModel.remoteRenderer!.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}