import 'package:flutter/material.dart';
import 'package:flutter_client/view/app_theme.dart';
import 'package:flutter_client/view/common/incoming_call_layout.dart';
import 'package:flutter_client/view/desktop/main_desktop_layout.dart';
import 'package:flutter_client/view/mobile/main_mobile_layout.dart';

import 'app_size.dart';

class MainLayout extends StatefulWidget {
  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {

  @override
  Widget build(BuildContext context) {

    AppSizes.resetWidth(context);
    return Material(
        type: MaterialType.transparency,
        child: SafeArea(
            child: Stack(children: [
              Container(
                color: AppTheme.background,
                child: AppSizes.isMobile ? MainMobileLayout() : MainDesktopLayout(),
              ),
              IncomingCallLayout()
            ],)
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
