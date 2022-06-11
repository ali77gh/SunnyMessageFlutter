
import 'dart:async';
import 'dart:convert';

import 'package:flutter_client/view_model/contact_view_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{

  static const SERVER_ADDRESS = "ws://127.0.0.1:3000/";
  static const RECONNECT_TIME = 1000;

  static WebSocketChannel? channel;
  static bool isConnect = false;
  static bool isRegister = false;

  static init(){
    connect();
    reconnectLoop();
  }
  static connect(){
    channel = IOWebSocketChannel.connect(
      Uri.parse(SERVER_ADDRESS),
      pingInterval: const Duration(milliseconds: 10000)
    );

    channel?.stream.listen((message) {
      onMessage(jsonDecode(message));
    }, onError: (e){
      print(e.toString());
      isConnect = false;
      isRegister = false;
    }, onDone: (){
      // on disconnect
      print("on done");
      print("disconnect: ${channel?.closeReason}");
      isConnect = false;
      isRegister = false;
    }, cancelOnError: true);

    isConnect = true;
  }

  static reconnectLoop(){
    Timer.periodic(const Duration(milliseconds: RECONNECT_TIME), (timer) {
      if(!isConnect){
        connect();
      }else if(!isRegister){
        sendJoin(
            ContactViewModel.contacts.value.map(
                    (e) => e.roomId
            ).toList()
        );
        isRegister = true;
      }


      //TODO test publish() and check if other side get packet
    });
  }

  static send(String data){
    channel?.sink.add(data);
  }
  static sendJson(dynamic data){
    send(jsonEncode(data));
  }

  static onMessage(dynamic msg){
    if(msg["action"]==null) return;

      switch(msg["action"]){
        case "online_status":

          break;
        case "error":
          //read "message" string
          break;
      }
  }

  static sendJoin(List<String> roomIds){
    sendJson(
      {
        "action":"join",
        "rooms":roomIds
      }
    );
  }

  static publish(String roomId, dynamic data){
    sendJson(
        {
          "action":"publish",
          "room_id":roomId,
          "data":data
        }
    );
  }
}