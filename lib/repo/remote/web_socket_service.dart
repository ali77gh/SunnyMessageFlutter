
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService{

  static const SERVER_ADDRESS = "ws://127.0.0.1:3000/";

  static WebSocketChannel? channel;

  static init(){

    channel = WebSocketChannel.connect(
      Uri.parse(SERVER_ADDRESS),
    );

    channel?.stream.listen((message) {
        onMessage(jsonDecode(message));
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