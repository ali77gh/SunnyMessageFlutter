
import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/repo/local/contact_repo.dart';
import 'package:flutter_client/tools/observable.dart';

class ContactViewModel{

  static var contacts = Observable<List<Contact>>([]);

  static void subscribe(Function callback){
    contacts.subscribe(callback);
  }

  static void add(Contact contact){
    contacts.value.add(contact);
    contacts.notifyAll();
    ContactRepo.add(contact);
  }

  static void setOnlineStatus(String roomId,bool status){
    contacts.value.singleWhere((element) => element.roomId==roomId).online = status;
    contacts.notifyAll();
  }

  static List<Contact> get sorted_contacts{
    return contacts.value; // TODO sort by last message time
  }

  static void update(Contact contact){
    var index = contacts.value.indexWhere((element) => element.roomId==contact.roomId);
    contacts.value[index] = contact;
    contacts.notifyAll();
    ContactRepo.update(contact);
  }


  static void remove(String contactId){
    contacts.value.where((element) => element.roomId != contactId);
    contacts.notifyAll();
    ContactRepo.removeById(contactId);
  }
}