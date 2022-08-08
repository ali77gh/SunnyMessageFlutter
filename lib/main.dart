import 'package:flutter/material.dart';
import 'package:flutter_client/build_configs.dart';
import 'package:flutter_client/fake_data.dart';
import 'package:flutter_client/repo/local/contact_repo.dart';
import 'package:flutter_client/repo/remote/web_socket_service.dart';
import 'package:flutter_client/view/main_layout.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // fix shared preferences

  // start services here

  //web socket service
  WebSocketService.init();

  //local data providers
  if(BuildConfig.fake_data) {
    FakeData.load();
  } else {
    ContactRepo.init((){
      ContactViewModel.contacts.value = ContactRepo.getAll();
    });
  }
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
