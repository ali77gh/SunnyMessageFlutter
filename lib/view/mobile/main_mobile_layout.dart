import 'package:flutter/material.dart';
import 'package:flutter_client/view/common/chat_layout.dart';
import 'package:flutter_client/view/common/contact_list_layout.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';

class MainMobileLayout extends StatefulWidget {
  @override
  State<MainMobileLayout> createState() => MainMobileLayoutState();
}

class MainMobileLayoutState extends State<MainMobileLayout> {

  MainMobileLayoutState(){
    ChatViewModel.contact.subscribe((){ setState(() { }); });
  }

  @override
  Widget build(BuildContext context) {
    return ChatViewModel.isContactSelected ? ChatLayout() : ContactListLayout();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
