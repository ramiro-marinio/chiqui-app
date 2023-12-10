import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/chat_page.dart';

class ChatTile extends StatelessWidget {
  final UserData? userData;
  final GymData gymData;
  final List<UserData?> users;
  final bool publicChat;
  const ChatTile(
      {super.key,
      required this.userData,
      required this.gymData,
      required this.users,
      required this.publicChat});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userData?.displayName ?? 'Public Chat'),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: userData?.photoURL != null
            ? NetworkImage(userData!.photoURL!)
            : const AssetImage('assets/group.jpg') as ImageProvider,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              gymData: gymData,
              otherUser: userData?.userId,
              users: users,
              publicChat: publicChat,
            ),
          ),
        );
      },
    );
  }
}
