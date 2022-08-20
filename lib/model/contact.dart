
import 'dart:convert';

class Contact{

  String name;
  String roomId;
  bool online = false;

  Contact(this.name, this.roomId, this.online);

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        roomId = json['roomId'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roomId': roomId,
    };
  }

  static Contact parse(dynamic obj){
      return Contact(obj["name"], obj["roomId"],false);
  }

  static List<Contact> parseList(String string){
    return (jsonDecode(string) as List<dynamic>).map((e) => parse(e)).toList();
  }
}