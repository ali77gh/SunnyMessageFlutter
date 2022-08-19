import 'package:flutter/material.dart';
import 'package:flutter_client/model/contact.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/app_theme.dart';
import 'package:flutter_client/view/common/add_room_layout.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';
import 'package:flutter_client/view_model/contact_view_model.dart';
import 'package:flutter_client/view_model/add_room_view_model.dart';


class ContactListLayout extends StatefulWidget {
  @override
  State<ContactListLayout> createState() => ContactListLayoutState();
}

class ContactListLayoutState extends State<ContactListLayout> {

  ContactListLayoutState(){
    ContactViewModel.contacts.subscribe((){ setState(() { }); });
    ChatViewModel.contact.subscribe((){ setState(() { }); });
    AddRoomViewModel.isVisible.subscribe((){ setState(() { });});
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.background_2,
      child: Column(
        children: [
          logoAndName(),
          const SizedBox(height: 20),
          list(),
          buttonsOrDialogs()
        ],
      ),
    );
  }

  Widget logoAndName(){
    return Container(
      height: AppSizes.topBarSize,
      color: AppTheme.primary,
        padding: const EdgeInsets.all(4),
        child: Row(
            children: [
              const SizedBox(width: 4),
              Image.asset(
                  'assets/logo.png',
                  height: AppSizes.fontLarge*2,
                  color: AppTheme.text_sharp
              ),
              const SizedBox(width: 4),
              Text(
                  "Sunny Message",
                  style: TextStyle(
                      fontSize: AppSizes.fontLarge,
                      color: AppTheme.text_sharp
                  )
              )
            ]
        )
    );
  }

  Widget list(){
    return Expanded(
      child: ListView(
        children: ContactViewModel.sortedContacts.map((e) => listItem(e)).toList(),
      ),
    );
  }

  Widget buttonsOrDialogs(){
    if(AddRoomViewModel.isVisible.value){
      return AddRoomLayout();
    } else {
      return buttons();
    }
  }

  Widget buttons(){
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            const Spacer(),
            FloatingActionButton(
                onPressed: (){
                  AddRoomViewModel.show(AddRoomViewModel.MODE_CREATE);
                },
                child: Image.asset(
                  height: AppSizes.fontLarge,
                  width: AppSizes.fontLarge,
                  "assets/create_room.png",
                )
            ),
            const Spacer(),
            FloatingActionButton(
                onPressed: (){
                  AddRoomViewModel.show(AddRoomViewModel.MODE_JOIN);
                },
                child: Image.asset(
                  height: AppSizes.fontLarge,
                  width: AppSizes.fontLarge,
                  "assets/join_room.png",
                )
            ),
            const Spacer(),
          ],
        )
    );
  }

  Widget listItem(Contact contact){

    bool isSelected(){
      if(ChatViewModel.contact.value == null) return false;
      return contact.roomId==ChatViewModel.contact.value!.roomId;
    }

    return GestureDetector(
        onTap: (){
          // ChatViewModel.contact.value = contact;
          ChatViewModel.load(contact);
        },
        child: Container(
            padding: const EdgeInsets.all(4),
            color:  isSelected() ? AppTheme.background :AppTheme.background_2 ,
            child: Row(
                children: [
                  const SizedBox(width: 4),
                  Image.asset(
                      'assets/contact.png',
                      height: AppSizes.fontLarge*2,
                      color: AppTheme.text_sharp
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          contact.name,
                          style: TextStyle(
                              fontSize: AppSizes.fontLarge,
                              color: AppTheme.text_sharp,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      Text(
                          contact.online ? "connect" : "disconnect",
                          style: TextStyle(
                              fontSize: AppSizes.fontSmall,
                              color: contact.online ? AppTheme.primary : AppTheme.text_normal ,
                              fontWeight: contact.online ? FontWeight.bold : FontWeight.normal
                          )
                      )
                    ],
                  )
                ]
            )
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
