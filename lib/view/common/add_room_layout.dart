
import 'package:flutter/material.dart';
import 'package:flutter_client/view_model/add_room_view_model.dart';


class AddRoomLayout extends StatefulWidget {
  @override
  State<AddRoomLayout> createState() => AddRoomLayoutState();
}

class AddRoomLayoutState extends State<AddRoomLayout> {

  AddRoomLayoutState(){
    AddRoomViewModel.roomId.subscribe((){setState(() { });});
    AddRoomViewModel.name.subscribe((){setState(() { });});
    AddRoomViewModel.isValid.subscribe((){setState(() { });});
  }

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController()..text = AddRoomViewModel.roomId.value;
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Contact Name"
            ),
            onChanged: (text){
              AddRoomViewModel.onNameChange(text);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: (AddRoomViewModel.mode == AddRoomViewModel.MODE_CREATE) ? controller : null,
            readOnly: AddRoomViewModel.mode == AddRoomViewModel.MODE_CREATE,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Room Id"
            ),
            onChanged: (text){
              AddRoomViewModel.onRoomIdChange(text);
            },
          ),
          const SizedBox(height: 10),
          Row(children: [
            const Spacer(),
            TextButton(
                onPressed: (){
                  AddRoomViewModel.close();
                },
                child: const Text("Cancel")
            ),
            if(AddRoomViewModel.isValid.value)
              TextButton(
                  onPressed: (){
                    AddRoomViewModel.save();
                  },
                  child: const Text("Add")
              ),
            const Spacer(),
          ])
        ]
    )
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
