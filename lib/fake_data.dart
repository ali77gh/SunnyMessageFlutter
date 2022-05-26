

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

    ChatViewModel.messages.value.add(Message("سلام",0,true,false));
    ChatViewModel.messages.value.add(Message("سلام",0,true,true));
    ChatViewModel.messages.value.add(Message("خوبی؟",0,true,false));
    ChatViewModel.messages.value.add(Message("عالی ام",0,true,true));
    ChatViewModel.messages.value.add(Message("ای بابا",0,true,false));
    ChatViewModel.messages.value.add(Message("english harf bezanim yekam",0,true,false));
    ChatViewModel.messages.value.add(Message("english harf bezanim yekammmmmm",0,true,true));
    ChatViewModel.messages.value.add(Message("chera inja enghadr saketeeeee?!",0,false,true));
    ChatViewModel.messages.value.add(Message("سلام",0,true,false));
    ChatViewModel.messages.value.add(Message("سلام",0,true,true));
    ChatViewModel.messages.value.add(Message("خوبی؟",0,true,false));
    ChatViewModel.messages.value.add(Message("عالی ام",0,true,true));
    ChatViewModel.messages.value.add(Message("ای بابا",0,true,false));
    ChatViewModel.messages.value.add(Message("english harf bezanim yekam",0,true,false));
    ChatViewModel.messages.value.add(Message("english harf bezanim yekammmmmm",0,true,true));
    ChatViewModel.messages.value.add(Message("chera inja enghadr saketeeeee?!",0,false,true));
  }
}