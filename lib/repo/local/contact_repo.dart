
import 'dart:convert';

import 'package:flutter_client/model/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactRepo {

  static const String TABLE_NAME = "contact";

  static SharedPreferences? _sharedPreferences;
  static List<Contact> _contacts = [];

  static void init(Function onReady){
    SharedPreferences.getInstance().then((value){
      _sharedPreferences = value;
      _load();
      onReady();
    });
  }

  static void _load(){
    var content = _sharedPreferences!.getString(TABLE_NAME);
    if(content != null){
      _contacts = Contact.parseList(content);
    }
  }

  static void _save(){
    _sharedPreferences!.setString(TABLE_NAME, jsonEncode(_contacts));
  }

  static void add(Contact contact){
    _contacts.add(contact);
    _save();
  }

  static List<Contact> getAll(){
    return _contacts.toList();
  }

  static void update(Contact contact){
    _contacts[
      _contacts.indexOf(
          _contacts.singleWhere((element) => contact.roomId==element.roomId)
      )
    ] = contact;
    _save();
  }

  static void removeById(String roomId){
    _contacts.removeWhere((element)=> element.roomId==roomId);
    _save();
  }
}