
import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/tools/obsarvable.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';

class CreateRoomViewModel{

  static var isVisible = Observable<bool>(false);
  static var roomId = Observable<String>("");
  static var name = Observable<String>("");

  static bool get isNameValidate{
    return true;//TODO validate name
  }

  static void save(){
    var contact = Contact(name.value, roomId.value, false);
    ContactViewModel.add(contact);
  }

  static close(){
    isVisible.value = false;
    name.value = "";
    roomId.value = "";
  }

  static show(){
    isVisible.value = true;
  }

  static void onNameChange(String name){
    CreateRoomViewModel.name.value = name;
    //TODO validate name and create new UUID and load to roomId
  }

  static void copyRoomId(){
    // TODO read clipboard and load to
  }

}
