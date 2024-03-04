import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/invitesettings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/joinrequests/joinrequests.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/option.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/usersdisplayer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final appLocalizations = AppLocalizations.of(context)!;
    localMembershipSubscription ??= FirebaseFirestore.instance
        .collection('memberships')
        .where('gymId', isEqualTo: widget.gymData.id!)
        .where('userId', isEqualTo: applicationState.user!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        localMembershipData = MembershipData.fromJson(event.docs[0].data());
      });
    });
    users ??= applicationState.getGymUsers(widget.gymData.id!);
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.settings)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Option(
              icon: const Icon(CupertinoIcons.person_add),
              text: appLocalizations.inviteCode,
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
              icon: const Icon(CupertinoIcons.mail),
              text: appLocalizations.joinRequests,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return JoinRequests(
                      gymData: widget.gymData,
                    );
                  },
                ));
              },
            ),
            Option(
              icon: const Icon(CupertinoIcons.pencil),
              text: appLocalizations.editGymInfo,
              onTap: localMembershipData?.admin == true ||
                      applicationState.user!.uid == widget.gymData.ownerId
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateGym(editGym: widget.gymData),
                        ),
                      );
                    }
                  : null,
            ),
            Option(
              icon: const Icon(CupertinoIcons.money_dollar),
              text: appLocalizations.paymentPlan,
              onTap: null,
            ),
            const AdaptiveDivider(
              indent: 8,
              thickness: 0.3,
            ),
            localMembershipData != null
                ? UsersDisplayer(
                    gymData: widget.gymData,
                    localMembershipData: localMembershipData!)
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    localMembershipSubscription?.cancel();
    localMembershipSubscription = null;
  }
}
