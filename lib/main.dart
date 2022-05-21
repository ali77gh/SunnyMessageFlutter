import 'package:flutter/material.dart';
import 'package:flutter_client/build_configs.dart';
import 'package:flutter_client/fake_data.dart';
import 'package:flutter_client/view/main_layout.dart';

void main() {
  // start services here
  if(BuildConfig.fake_data) FakeData.load();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        theme: ThemeData(fontFamily: 'IranSans'),
        debugShowCheckedModeBanner: false,
        home: MainLayout()
    );
  }
}
