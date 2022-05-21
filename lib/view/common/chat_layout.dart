import 'package:flutter/material.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/app_theme.dart';


class ChatLayout extends StatefulWidget {
  @override
  State<ChatLayout> createState() => ChatLayoutState();
}

class ChatLayoutState extends State<ChatLayout> {

  @override
  Widget build(BuildContext context) {

    return Container(
      alignment: Alignment.center,
      child: Text(
        "select a chat",
        style: TextStyle(color: AppTheme.text_sharp,fontSize: AppSizes.fontSmall)),
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
