
import 'package:flutter_client/model/message.dart';

class MessageRepo{

  // messages saves on RAM
  static Map<String,List<Message>> _messages = {};


  static void add(String contactId, Message message){
    if(_messages[contactId]==null){
      _messages[contactId] = [];
    }
    _messages[contactId]!.add(message);
  }

  static List<Message> getAll(String contactId){
    if(_messages[contactId]==null){
      _messages[contactId] = [];
    }
    return _messages[contactId]!.toList();
  }
}