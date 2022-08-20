

import 'dart:convert';

class Message{

  String content;
  int time;
  bool delivered;
  bool selfSend;

  Message(this.content, this.time, this.delivered, this.selfSend);

  Message.fromJson(Map<String, dynamic> json)
      : content = json['contact'],
        time = json['time'],
        delivered = json['delivered'],
        selfSend = json['selfSend'];

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'time': time,
      'delivered': delivered,
      'selfSend': selfSend,
    };
  }

  static Message parse(dynamic obj){
    return Message(obj["content"], obj["time"], obj["delivered"], obj["selfSend"]);
  }

  static List<Message> parseList(String string){
    return (jsonDecode(string) as List<dynamic>).map((e) => parse(e)).toList();
  }
}