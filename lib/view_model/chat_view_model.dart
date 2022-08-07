
import 'package:flutter/widgets.dart';
import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/repo/local/message_repo.dart';
import 'package:flutter_client/tools/observable.dart';

import '../model/message.dart';

class ChatViewModel{

  static var contact = Observable<Contact?>(null);
  static var messages = Observable<List<Message>>([]);
  static var inputMessage = Observable<String>("");

  static var tec = TextEditingController();

  static void unSelectContact(){
    contact.value = null;
  }

  static bool get isContactSelected => contact.value!=null;

  static void sendMessage(){

    if(inputMessage.value == "") return; // TODO validate and disable and enable send button

    var msg = Message(inputMessage.value, DateTime.now().millisecondsSinceEpoch, false, true);
    messages.value.add(msg);
    messages.notifyAll();
    inputMessage.value = "";
    tec.clear();
    // TODO send with Webrtc
    MessageRepo.add(contact.value!.roomId, msg);
  }

  /*
  * call from Messaging Service
  * */
  static void onNewMessage(Message message){
    messages.value.add(message);
    messages.notifyAll();
    MessageRepo.add(contact.value!.roomId, message);
  }

  static void load(Contact contact){
    ChatViewModel.contact.value = contact;
    // load messages
    messages.value = MessageRepo.getAll(contact.roomId);
  }

  static void onInputMessageChange(String msg){
    inputMessage.value = msg;
  }
}
