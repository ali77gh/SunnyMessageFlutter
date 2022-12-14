import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_client/model/message.dart';
import 'package:flutter_client/repo/remote/peer_to_peer_connection.dart';
import 'package:flutter_client/view/app_size.dart';
import 'package:flutter_client/view/app_theme.dart';
import 'package:flutter_client/view/common/video_call_layout.dart';
import 'package:flutter_client/view_model/chat_view_model.dart';
import 'package:flutter_client/view_model/video_call_view_model.dart';


class ChatLayout extends StatefulWidget {
  @override
  State<ChatLayout> createState() => ChatLayoutState();
}

class ChatLayoutState extends State<ChatLayout> {

  ChatLayoutState(){
    ChatViewModel.contact.subscribe((){ setState(() { }); });
    ChatViewModel.messages.subscribe((){ setState(() { }); });
    ChatViewModel.inputMessage.subscribe((){ setState(() { }); });
    VideoCallViewModel.state.subscribe((){ setState(() { }); });
  }


  @override
  Widget build(BuildContext context) {

    if(!ChatViewModel.isContactSelected){
      return chatNotSelected();
    }

    if(VideoCallViewModel.state.value == CallState.NormalTextChat){
      return Column(children: [
        topBar(),
        Expanded(child: messageList()),
        inputText(),
      ]);
    }

    return Column(children: [
      topBar(),
      Expanded(child: VideoChatLayout()),
    ]);
  }

  Widget chatNotSelected(){
    return Container(
      alignment: Alignment.center,
      child: Text(
          "select a chat",
          style: TextStyle(color: AppTheme.text_sharp, fontSize: AppSizes.fontSmall)
      ),
    );
  }

  Widget topBar(){

    var contact = ChatViewModel.contact.value;

    return Container(
      color: AppTheme.primary,
      height: AppSizes.topBarSize,
      width: double.infinity,
      child: Row(
        children: [
          // white line
          Container(
            color: AppTheme.background_2,
            width: 2,
            height: double.infinity,
          ),
          const SizedBox(width: 15),
          GestureDetector(
            child:Image.asset(
              "assets/back.png",
              width: AppSizes.fontLarge,
              height: AppSizes.fontLarge,
            ),
            onTap: (){
              ChatViewModel.unSelectContact();
              PeerToPeerConnection.hangUp();
              VideoCallViewModel.state.value = CallState.NormalTextChat;
            },
          ),

          const SizedBox(width: 15),

          Text(
            contact==null ? "" : contact.name + (contact.online ? " (online)" : " (offline)") ,
            style: TextStyle(fontSize: AppSizes.fontLarge),
          ),

          const Spacer(),

          GestureDetector(
            child:Image.asset(
              (VideoCallViewModel.state.value==CallState.NormalTextChat) ? "assets/videocam.png" : "assets/disable_videocam.png",
              width: AppSizes.fontLarge,
              height: AppSizes.fontLarge,
            ),
            onTap: (){
              if(VideoCallViewModel.state.value == CallState.NormalTextChat){
                PeerToPeerConnection.openUserMedia();
                VideoCallViewModel.state.value = CallState.JustLocalCamera;
              }else{
                VideoCallViewModel
                    .localRenderer
                    ?.srcObject
                    ?.getTracks()
                    .forEach((element) { element.stop(); });
                VideoCallViewModel.state.value = CallState.NormalTextChat;
                PeerToPeerConnection.hangUp();
              }
              // TODO
            },
          ),

          const SizedBox(width: 15),

        ],
      ),
    );
  }

  final _controller = ScrollController();
  Widget messageList(){

    // scroll to end
    Timer(const Duration(milliseconds: 0),
          () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );

    return ListView(
      controller: _controller,
      padding: const EdgeInsets.all(10),
      children: ChatViewModel.messages.value.map((e) => messageItem(e)).toList(),
    );
  }

  Widget messageItem(Message message){

    return Container(
      margin: const EdgeInsets.all(10),
      alignment: message.selfSend ? Alignment.centerRight :Alignment.centerLeft,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
              color: message.selfSend ? AppTheme.primary : AppTheme.secondary,
              padding: const EdgeInsets.all(15),
              child: Text(message.content)
          )
      ),
    );
  }

  Widget inputText(){
    return Container(
        margin: const EdgeInsets.all(5),
        child: Row(children: [
          Expanded(
              child: TextField(
                maxLines: 4,
                minLines: 1,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Message"
                ),
                controller: ChatViewModel.tec,
                onChanged: (text){
                  ChatViewModel.inputMessage.value = text;
                },
              )
          ),
          GestureDetector(
              child: Image.asset(
                "assets/send.png",
                color: AppTheme.primary,
                width: 50,
                height: 50
              ),
            onTap: (){
                ChatViewModel.sendMessage();
            },
          )
        ],)
    );
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
