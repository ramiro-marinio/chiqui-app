import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/invitesettings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/option.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/usersettingstile.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final GymData gymData;
  const SettingsPage({super.key, required this.gymData});
  @override
  Widget build(BuildContext context) {
    MembershipData? localMembershipData;
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    FirebaseFirestore.instance
        .collection('memberships')
        .where('gymId', isEqualTo: gymData.id!)
        .where('userId', isEqualTo: applicationState.user!.uid)
        .snapshots()
        .listen((event) {
      localMembershipData = MembershipData.fromJson(event.docs[0].data());
    });
    final Future<List<UserData?>> users =
        applicationState.getGymUsers(gymData.id!);
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: Column(
              children: [
                Option(
                  icon: const Icon(Icons.group_add),
                  text: 'Invite Code',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InviteSettings(
                          gymData: gymData,
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
                        builder: (context) => CreateGym(editGym: gymData),
                      ),
                    );
                  },
                ),
                ...List.generate(
                  snapshot.data!.length,
                  (index) => UserSettingsTile(
                    userData: snapshot.data![index]!,
                    gymId: gymData.id!,
                    localMembershipData: localMembershipData!,
                  ),
                ),
              ],
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
}
