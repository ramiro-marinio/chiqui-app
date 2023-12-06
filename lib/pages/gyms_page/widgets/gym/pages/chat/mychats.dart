import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/messagedata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/chat/widgets/messagecard.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/chat/widgets/messagetyper.dart';
import 'package:provider/provider.dart';

class MyChats extends StatefulWidget {
  final GymData gymData;
  const MyChats({super.key, required this.gymData});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  Future<List<UserData?>>? users;
  List<MessageData>? messages;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      ApplicationState applicationState =
          Provider.of<ApplicationState>(context);
      users ??= applicationState.getGymUsers(widget.gymData.id!);
      FirebaseFirestore.instance
          .collection('messages')
          .where('gymId', isEqualTo: widget.gymData.id!)
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((event) {
        setState(() {
          messages = List.generate(event.docs.length,
              (index) => MessageData.fromJson(event.docs[index].data()));
        });
      });
      return FutureBuilder(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(
                      messages!.length,
                      (index) => MessageCard(
                        messageData: messages![index],
                        users: snapshot.data!,
                      ),
                    ),
                  ),
                ),
                const AdaptiveDivider(
                  indent: 0,
                  thickness: 0.2,
                ),
                MessageTyper(
                  onSubmit: (value) {
                    applicationState.sendMessage(MessageData(
                        message: value,
                        gymId: widget.gymData.id!,
                        senderId: applicationState.user!.uid,
                        receiverId: null,
                        timestamp: DateTime.now().millisecondsSinceEpoch));
                  },
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      );
    });
  }
}
