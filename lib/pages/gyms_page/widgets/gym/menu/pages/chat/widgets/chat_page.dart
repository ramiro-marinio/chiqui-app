import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/functions/processmessagedocs.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/messagecard.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/messagetyper.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final GymData gymData;
  final String? otherUser;
  final List<UserData?> users;
  final bool publicChat;
  const ChatPage({
    super.key,
    required this.gymData,
    required this.otherUser,
    required this.users,
    required this.publicChat,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageData> myMessages = [];
  List<MessageData> theirMessages = [];
  List<MessageData> messages = [];
  late ApplicationState applicationState;
  @override
  void initState() {
    super.initState();
    applicationState = context.read<ApplicationState>();
    //Listener for messages from the client user
    if (widget.publicChat == false) {
      applicationState
          .getChatStream(
              gymId: widget.gymData.id!,
              senderId: applicationState.user!.uid,
              receiverId: widget.otherUser)
          .listen((event) {
        setState(() {
          myMessages = processMessageDocs(event.docs);
          messages = myMessages + theirMessages;
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
      //Listener for messages from other user
      applicationState
          .getChatStream(
              gymId: widget.gymData.id!,
              senderId: widget.otherUser,
              receiverId: applicationState.user!.uid)
          .listen((event) {
        setState(() {
          theirMessages = processMessageDocs(event.docs);
          messages = myMessages + theirMessages;
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
    } else {
      applicationState
          .getChatStream(
              gymId: widget.gymData.id!, receiverId: null, senderId: null)
          .listen((event) {
        setState(() {
          messages = processMessageDocs(event.docs);
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: List.generate(
                messages.length,
                (index) => MessageCard(
                  messageData: messages[index],
                  users: widget.users,
                ),
              ),
            ),
          ),
          MessageTyper(
            onSubmit: (value) {
              applicationState.sendMessage(
                MessageData(
                    message: value,
                    gymId: widget.gymData.id!,
                    senderId: applicationState.user!.uid,
                    receiverId: widget.otherUser,
                    timestamp: DateTime.now().millisecondsSinceEpoch),
              );
            },
          )
        ],
      ),
    );
  }
}
