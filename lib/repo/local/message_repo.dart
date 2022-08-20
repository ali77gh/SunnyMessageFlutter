
import 'dart:convert';

import 'package:flutter_client/model/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageRepo{

  static const String TABLE_NAME = "messages";
  static String tableName(String contactId) => "${TABLE_NAME}_$contactId";

  static SharedPreferences? _sharedPreferences;

  static void init(){
    SharedPreferences.getInstance().then((value){
      _sharedPreferences = value;
    });
  }

  static void _save(String contactId, List<Message> messages){
    _sharedPreferences!.setString(tableName(contactId), jsonEncode(messages));
  }

  static List<Message> _load(String contactId){
    var content = _sharedPreferences!.getString(tableName(contactId));
    if(content == null){
      return [];
    }
    return Message.parseList(content);
  }

  static void add(String contactId, Message message){
    _save(contactId, _load(contactId)..add(message));
  }

  static List<Message> getAll(String contactId) => _load(contactId);

}