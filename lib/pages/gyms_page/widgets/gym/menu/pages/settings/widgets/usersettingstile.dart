import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/calcage.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/functions/useroptionsmenu.dart';
import 'package:provider/provider.dart';

class UserSettingsTile extends StatefulWidget {
  final UserData userData;
  final GymData gymData;
  final MembershipData localMembershipData;
  const UserSettingsTile(
      {super.key,
      required this.userData,
      required this.gymData,
      required this.localMembershipData});

  @override
  State<UserSettingsTile> createState() => _UserSettingsTileState();
}

class _UserSettingsTileState extends State<UserSettingsTile> {
  StreamSubscription? subscription;
  StreamSubscription? mySubscription;
  MembershipData? membership;
  bool? coach;
  bool? admin;

  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    subscription ??= FirebaseFirestore.instance
        .collection('memberships')
        .where('gymId', isEqualTo: widget.gymData.id!)
        .where('userId', isEqualTo: widget.userData.userId)
        .snapshots()
        .listen((value) {
      setState(() {
        membership = MembershipData.fromJson(value.docs[0].data());
        coach = membership!.coach;
        admin = membership!.admin;
      });
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        color: adaptiveColor(const Color.fromARGB(255, 181, 203, 255),
            const Color.fromARGB(255, 46, 46, 71), context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          splashColor: const Color.fromARGB(100, 255, 255, 255),
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTapUp: (details) {
            showUserOptionsMenu(
              context: context,
              details: details,
              membership: membership!,
              applicationState: applicationState,
              localMembershipData: widget.localMembershipData,
              gymData: widget.gymData,
              userData: widget.userData,
            );
          },
          child: ListTile(
            title: Text(widget.userData.displayName),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: widget.userData.photoURL != null
                  ? NetworkImage(widget.userData.photoURL!)
                  : const AssetImage('assets/no_image.jpg') as ImageProvider,
            ),
            subtitle: Row(
              children: [
                widget.userData.info.isNotEmpty
                    ? Expanded(
                        child: Text(
                        widget.userData.info,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                    : const Text('No info'),
                coach != null
                    ? Visibility(
                        visible: coach!,
                        child: const Icon(Icons.fitness_center),
                      )
                    : const CircularProgressIndicator.adaptive(),
                admin != null
                    ? Visibility(
                        visible: admin!,
                        child: const Icon(Icons.shield),
                      )
                    : const CircularProgressIndicator.adaptive(),
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Icon(widget.userData.sex ? Icons.female : Icons.male),
                      Text(
                        widget.userData.sex ? 'Female' : 'Male',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text('${calculateAge(widget.userData.birthDay)} years old'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
