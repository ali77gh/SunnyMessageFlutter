
import 'package:ptopwebrtc/model/contact.dart';
import 'package:ptopwebrtc/tools/obsarvable.dart';
import 'package:ptopwebrtc/view_model/contact_view_model.dart';

class JoinRoomViewModel{

  static var isVisible = Observable<bool>(false);
  static var roomId = Observable<String>("");
  static var name = Observable<String>("");

  static bool get isRoomIdValidate{
    return true;//TODO validate UUID
  }

  static bool get isNameValidate{
    return true;//TODO validate name
  }

  static bool get isValidate{
    return isNameValidate && isRoomIdValidate;
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
    pasteRoomId();
    if(!isRoomIdValidate){
      roomId.value = "";
    }
  }

  static void onRoomIdChange(String roomId){
    JoinRoomViewModel.roomId.value = roomId;
  }

  static void pasteRoomId(){
    // TODO read clipboard and load to
  }

  static void onNameChange(String name){
    JoinRoomViewModel.name.value = name;
  }
}
