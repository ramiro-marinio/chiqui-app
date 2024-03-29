import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    Future<QuerySnapshot<Map<String, dynamic>>>? membershipData;
    if (userData != null) {
      membershipData = FirebaseFirestore.instance
          .collection('memberships')
          .where('gymId', isEqualTo: gymData.id!)
          .where('userId', isEqualTo: userData!.userId)
          .get();
    }
    return ListTile(
      title: Text(userData?.displayName ?? appLocalizations.publicChat),
      leading: publicChat
          ? const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/group.jpg'),
            )
          : ZoomAvatar(
              photoURL: userData?.photoURL,
              radius: 20,
              tag: UniqueKey().toString(),
              gymImage: false,
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
                    tag = appLocalizations.ownerTag;
                  } else if (data.admin && data.coach) {
                    tag = appLocalizations.coachAdminTag;
                  } else if (data.admin) {
                    tag = appLocalizations.adminTag;
                  } else if (data.coach) {
                    tag = appLocalizations.coachTag;
                  }
                  return Text(
                    tag,
                    style: TextStyle(
                      color: adaptiveColor(
                        const Color.fromARGB(255, 131, 78, 0),
                        Colors.orange,
                        context,
                      ),
                    ),
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
        context.push('/my-gyms/gym-menu/chat', extra: {
          'gymId': gymData.id!,
          'otherUser': userData,
          'users': users,
          'publicChat': publicChat,
        });
      },
    );
  }
}
