import 'package:flutter/material.dart';
import 'package:frontend/src/config/config.dart';
import 'package:frontend/src/constatnts/color_strings.dart';
import 'package:frontend/src/controller/chat_controller.dart';
import 'package:frontend/src/model/message.dart';
import 'package:frontend/src/widget/message_item_widget.dart';
import 'package:get/get.dart';
import "package:socket_io_client/socket_io_client.dart" as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgInputControllers = TextEditingController();
  late IO.Socket socket;
  ChatController chatController = ChatController();
  @override
  void initState() {
    socket = IO.io(
      Config.url,
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build(),
    );
    socket.connect();
    setUpSocketListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(socket.id);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 9,
            child: Obx(
              () => ListView.builder(
                itemCount: chatController.chatMessages.length,
                itemBuilder: (context, index) {
                  var currentItem = chatController.chatMessages[index];
                  return MessageItem(
                    msg: currentItem.message!,
                    sendByMe: currentItem.sentByMe == socket.id,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.purple,
                controller: msgInputControllers,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        sendMsg(msgInputControllers.text);
                        msgInputControllers.text = "";
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setUpSocketListener() {
    socket.on("message-recive", (data) {
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });
  }

  void sendMsg(String text) {
    var messageJson = {"message": text, "sender": socket.id};
    socket.emit('message', messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));
  }
}
