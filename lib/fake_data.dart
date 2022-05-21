

import 'dart:async';

import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/model/message.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';

class FakeData{

  static void load(){
    loadContacts();
    loadChat();
  }

  static var mohammad = Contact("Mohammad","2",false);
  static void loadContacts(){

    ContactViewModel.add(Contact("Ali","1",false));
    Timer(const Duration(milliseconds: 1000),(){
      ContactViewModel.add(mohammad);
      ContactViewModel.add(Contact("Hooman","3",true));
      ContactViewModel.add(Contact("Amin","4",false));
    });
  }

  static void loadChat(){
    Timer(const Duration(milliseconds: 3000),(){
      ChatViewModel.messages.value.add(Message("1", DateTime.now().millisecondsSinceEpoch, false));
      ChatViewModel.messages.value.add(Message("2", DateTime.now().millisecondsSinceEpoch, false));
      ChatViewModel.messages.notifyAll();
      Timer(const Duration(milliseconds: 3000),(){
        ChatViewModel.messages.value.add(Message("3", DateTime.now().millisecondsSinceEpoch, true));
        ChatViewModel.messages.value.add(Message("4", DateTime.now().millisecondsSinceEpoch, false));
        ChatViewModel.messages.notifyAll();
      });
    });
  }
}