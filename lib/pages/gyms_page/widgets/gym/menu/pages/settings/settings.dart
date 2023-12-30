import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/processusersettings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/invitesettings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/option.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/usersettingstile.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:gymapp/widgets/filterbar.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final GymData gymData;
  const SettingsPage({super.key, required this.gymData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<List<UserData>>? users;
  MembershipData? localMembershipData;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      localMembershipSubscription;
  String search = '';
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    localMembershipSubscription ??= FirebaseFirestore.instance
        .collection('memberships')
        .where('gymId', isEqualTo: widget.gymData.id!)
        .where('userId', isEqualTo: applicationState.user!.uid)
        .snapshots()
        .listen((event) {
      localMembershipData = MembershipData.fromJson(event.docs[0].data());
    });
    users ??= applicationState.getGymUsers(widget.gymData.id!);
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            localMembershipData != null) {
          List<UserData> processedUsers =
              processUserSettings(snapshot.data!, context);
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Option(
                    icon: const Icon(Icons.group_add),
                    text: 'Invite Code',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InviteSettings(
                            gymData: widget.gymData,
                          ),
                        ),
                      );
                    },
                  ),
                  Option(
                    icon: const Icon(Icons.edit),
                    text: 'Edit Gym Info',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateGym(editGym: widget.gymData),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterBar(
                      onChanged: (value) {
                        setState(() {
                          search = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  ...List.generate(processedUsers.length, (index) {
                    return Visibility(
                      visible: processedUsers[index]
                          .displayName
                          .toLowerCase()
                          .contains(search),
                      child: UserSettingsTile(
                        userData: processedUsers[index],
                        gymData: widget.gymData,
                        localMembershipData: localMembershipData!,
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    localMembershipSubscription?.cancel();
    localMembershipSubscription = null;
    users = null;
  }
}
