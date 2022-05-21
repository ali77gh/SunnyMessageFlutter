import 'package:flutter/material.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/common/chat_layout.dart';
import 'package:flutter_client/view/common/contact_list_layout.dart';


class MainDesktopLayout extends StatefulWidget {
  @override
  State<MainDesktopLayout> createState() => MainDesktopLayoutState();
}

class MainDesktopLayoutState extends State<MainDesktopLayout> {

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          SizedBox(
            width: 320,
            height: AppSizes.height,
            child: ContactListLayout(),
          ),
        Expanded(child: ChatLayout())
      ],
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
