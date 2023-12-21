import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
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
    Future<QuerySnapshot<Map<String, dynamic>>>? membershipData;
    if (userData != null) {
      membershipData = FirebaseFirestore.instance
          .collection('memberships')
          .where('gymId', isEqualTo: gymData.id!)
          .where('userId', isEqualTo: userData!.userId)
          .get();
    }
    return ListTile(
      title: Text(userData?.displayName ?? 'Public Chat'),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: userData?.photoURL != null
            ? NetworkImage(userData!.photoURL!)
            : AssetImage(
                    publicChat ? 'assets/group.jpg' : 'assets/no_image.jpg')
                as ImageProvider,
      ),
      subtitle: membershipData != null
          ? FutureBuilder(
              future: membershipData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  MembershipData data =
                      MembershipData.fromJson(snapshot.data!.docs[0].data());
                  String tag = ' ';
                  if (userData!.userId == gymData.ownerId) {
                    tag = 'Owner';
                  } else if (data.admin && data.coach) {
                    tag = 'Coach and Administrator';
                  } else if (data.admin) {
                    tag = 'Admin';
                  } else if (data.coach) {
                    tag = 'Coach';
                  }
                  return Text(
                    tag,
                    style: TextStyle(
                        color: adaptiveColor(
                            const Color.fromARGB(255, 131, 78, 0),
                            Colors.orange,
                            context)),
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
              },
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              gymId: gymData.id!,
              otherUser: userData,
              users: users,
              publicChat: publicChat,
            ),
          ),
        );
      },
    );
  }
}
