
import 'dart:async';
import 'dart:convert';

import 'package:flutter_client/view_model/contact_view_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{

  static const SERVER_ADDRESS = "ws://192.168.226.193:3000/";
  static const RECONNECT_TIME = 1000;

  static WebSocketChannel? channel;
  static bool isConnect = false;
  static bool isRegister = false;

  static init(){
    connect();
    reconnectLoop();
  }
  static connect(){
    channel = WebSocketChannel.connect(
      Uri.parse(SERVER_ADDRESS),
    );

    channel?.stream.listen((message) {
      print(message);
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

    });
  }

  // ----------- send -----------
  static send(String data){
    channel?.sink.add(data);
  }

  static sendJson(dynamic data){
    send(jsonEncode(data));
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
    sendJson({
      "action": "publish",
      "room_id": roomId,
      "data": data
    });
  }

  static sendICE(dynamic ice){
    var onlineFriends = ContactViewModel.contacts.value.where((element) => element.online);
    for (var friend in onlineFriends) {
      publish(friend.roomId, {
        "action": "ice",
        "ice": ice
      });
    }
  }

  // ----------- receive -----------
  static onMessage(dynamic msg){
    if(msg["action"]==null) return;

      switch(msg["action"]){
        case "online_status": onOnlineStatusRec(msg); break;
        case "error": onErrRec(msg); break;
        case "publish": onPublishRec(msg); break;
      }
  }

  static onOnlineStatusRec(dynamic msg){
    ContactViewModel.setOnlineStatus(msg["room_id"], msg["is_online"]);
  }

  static onErrRec(dynamic msg){
    print("incoming err message: " + msg["message"]);
    // TODO read "message" string Toast error
  }

  static onPublishRec(dynamic msg){
    var data = msg["data"];
    switch(data["action"]){
      case "ice": onICE(msg["roomId"], data["ice"]); break;
    }
  }

  static onICE(String roomId, dynamic data){

  }
}