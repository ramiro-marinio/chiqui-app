import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/alertsnackbar.dart';
import 'package:gymapp/functions/calcage.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:provider/provider.dart';

class UserSettingsTile extends StatefulWidget {
  final UserData userData;
  final String gymId;
  const UserSettingsTile(
      {super.key, required this.userData, required this.gymId});

  @override
  State<UserSettingsTile> createState() => _UserSettingsTileState();
}

class _UserSettingsTileState extends State<UserSettingsTile> {
  StreamSubscription? subscription;
  MembershipData? membership;
  bool? coach;
  bool? admin;

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return StatefulBuilder(builder: (context, setState) {
      subscription ??= FirebaseFirestore.instance
          .collection('memberships')
          .where('gymId', isEqualTo: widget.gymId)
          .where('userId', isEqualTo: widget.userData.userId)
          .snapshots()
          .listen((value) {
        setState(() {
          membership = MembershipData.fromJson(value.docs[0].data());
          coach = membership!.coach;
          admin = membership!.admin;
        });
      });
      return Card(
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onTapUp: (details) {
            showMenu(
                context: context,
                position: RelativeRect.fromDirectional(
                    textDirection: TextDirection.ltr,
                    start: details.globalPosition.dx,
                    top: details.globalPosition.dy,
                    end: details.globalPosition.dx,
                    bottom: details.globalPosition.dy),
                items: [
                  PopupMenuItem(
                    child: Text(coach != null
                        ? (coach! ? 'Remove Coach Role' : 'Make Coach')
                        : 'Loading...'),
                    onTap: () {
                      applicationState
                          .modifyMembership({'coach': !coach!}, membership!);
                      showAlertSnackbar(
                          context: context, text: 'Role Changed Successfully!');
                    },
                  ),
                  PopupMenuItem(
                    child: Text(admin != null
                        ? (admin!
                            ? 'Remove Administrator Role'
                            : 'Make Administrator')
                        : 'Loading...'),
                    onTap: () {
                      applicationState
                          .modifyMembership({'admin': !admin!}, membership!);
                      showAlertSnackbar(
                          context: context, text: 'Role Changed Successfully!');
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Kick Out'),
                    onTap: () {
                      showWarningDialog(
                        title: 'Are you sure?',
                        context: context,
                        yes: () {},
                      );
                    },
                  )
                ]);
          },
          child: ListTile(
            title: Text(widget.userData.displayName),
            leading: CircleAvatar(
              radius: 20,
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
                        overflow: TextOverflow.fade,
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
                  width: 100,
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
      );
    });
  }
}
