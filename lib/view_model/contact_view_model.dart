
import 'package:ptopwebrtc/model/contact.dart';
import 'package:ptopwebrtc/tools/obsarvable.dart';

class ContactViewModel{

  static var contacts = Observable<List<Contact>>([]);

  static void subscribe(Function callback){
    contacts.subscribe(callback);
  }

  static void add(Contact contact){
    contacts.value.add(contact);
    contacts.notifyAll();
    //TODO add to database
  }

  static List<Contact> get sorted_contacts{
    return contacts.value; // TODO sort by last message time
  }

  static void update(Contact contact){
    var index = contacts.value.indexWhere((element) => element.roomId==contact.roomId);
    contacts.value[index] = contact;
    contacts.notifyAll();
  }


  static void remove(String contactId){
    contacts.value.where((element) => element.roomId != contactId);
    contacts.notifyAll();
    //TODO remove from database
  }

  static void load(){
    //TODO load from database
  }
}