
import 'package:flutter/material.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/tools/nothing_widget.dart';
import 'package:flutter_client/view_model/video_call_view_model.dart';

class IncomingCallLayout extends StatefulWidget {
  @override
  State<IncomingCallLayout> createState() => IncomingCallLayoutState ();
}

class IncomingCallLayoutState extends State<IncomingCallLayout> {

  IncomingCallLayoutState(){
      VideoCallViewModel.callerRoomId.subscribe((){ setState((){}); });
  }

  @override
  Widget build(BuildContext context) {

    if(!VideoCallViewModel.isSomeoneCalling()) return const NothingWidget();

    return Container(
        color: const Color.fromARGB(200, 0, 0, 0),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "${VideoCallViewModel.callerName()} is calling you...",
              style: TextStyle(fontSize: AppSizes.fontLarge,color: Colors.white),
            ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                      color: Colors.green,
                      child:Image.asset(
                        "assets/call.png",
                        width: AppSizes.fontLarge,
                        height: AppSizes.fontLarge,
                      )
                  ),
                  onTap: (){
                    VideoCallViewModel.acceptCall();
                  },
                ),
                const Spacer(),
                GestureDetector(
                  child: Container(
                      padding: const EdgeInsets.all(40),
                      color: Colors.red,
                      child:Image.asset(
                    "assets/hangup.png",
                    width: AppSizes.fontLarge,
                    height: AppSizes.fontLarge,
                  )
                  ) ,
                  onTap: (){
                    VideoCallViewModel.reject();
                  },
                ),
                const Spacer(),
              ],
            ),
          ],
        )
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
