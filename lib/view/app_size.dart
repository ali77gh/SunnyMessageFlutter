import 'dart:math';

import 'package:flutter/material.dart';

const double WIDTH_MOBILE = 550;

const int PORTRATE = 0;
const int LANDSCAPE = 1;

const MOBILE = 0;
const NOT_MOBILE = 1;

class AppSizes{

  static double width = 0;
  static double height = 0;

  static int orientation = PORTRATE;

  static int deviceType = MOBILE;
  static bool get isMobile => deviceType == MOBILE;

  static void resetWidth(BuildContext context){
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    orientation = width>height ? LANDSCAPE : PORTRATE;

    double size = min(width, height);
    if(size < WIDTH_MOBILE) {
      deviceType = MOBILE;
    } else {
      deviceType = NOT_MOBILE;
    }
  }

  static double get topBarSize => 80;

  static double get sidePanelSize => deviceType==MOBILE ? width : width *.3;

  static double get bottomPanelSize => orientation == PORTRATE? height * .15 : height * .2;

  // text sizes
  static double get fontSmall  => isMobile ? 15 : 15;
  static double get fontNormal => isMobile ? 20 : 20;
  static double get fontLarge  => isMobile ? 30 : 30;
}
