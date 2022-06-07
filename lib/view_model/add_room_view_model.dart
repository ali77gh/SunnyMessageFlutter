import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/tools/obsarvable.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';
import 'package:uuid/uuid.dart';

class AddRoomViewModel{

  static const MODE_JOIN = "j";
  static const MODE_CREATE = "c";

  static var mode = "";
  static var isVisible = Observable<bool>(false);
  static var roomId = Observable<String>("");
  static var name = Observable<String>("");
  static var isValid = Observable(false);

  static bool get isRoomIdValidate{
    return roomId.value.length>30;
  }
  static bool get isNameValidate{
    return name.value.isNotEmpty;
  }

  static void save(){
    var contact = Contact(name.value, roomId.value, false);
    ContactViewModel.add(contact);
    close();
  }

  static close(){
    isVisible.value = false;
    isValid.value = false;
    name.value = "";
    roomId.value = "";
  }

  static show(String mode){
    AddRoomViewModel.mode = mode;
    isVisible.value = true;
    if(mode == AddRoomViewModel.MODE_CREATE){
      roomId.value = Uuid().v4();
    }
  }

  static void onNameChange(String name){
    AddRoomViewModel.name.value = name;
    updateIsValid();
  }
  static void onRoomIdChange(String name){
    AddRoomViewModel.roomId.value = name;
    updateIsValid();
  }

  static void updateIsValid(){
    AddRoomViewModel.isValid.value = isNameValidate && isRoomIdValidate;
  }

  static void copyRoomId(){
    // TODO read clipboard and load to
  }
  static void pasteRoomId(){
    // TODO read clipboard and load to
  }

}
