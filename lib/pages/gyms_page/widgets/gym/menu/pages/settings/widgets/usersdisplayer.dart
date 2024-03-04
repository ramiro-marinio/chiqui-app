import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/nousers.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/usersettingstile.dart';
import 'package:gymapp/widgets/filterbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersDisplayer extends StatefulWidget {
  final GymData gymData;
  final MembershipData localMembershipData;
  const UsersDisplayer({
    super.key,
    required this.gymData,
    required this.localMembershipData,
  });

  @override
  State<UsersDisplayer> createState() => _UsersDisplayerState();
}

class _UsersDisplayerState extends State<UsersDisplayer> {
  List<UserData> usersList = [];
  StreamSubscription? streamSubscription;
  int length = 0;
  String search = '';
  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
    streamSubscription = null;
    usersList = [];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    streamSubscription ??= FirebaseFirestore.instance
        .collection('memberships')
        .where('gymId', isEqualTo: widget.gymData.id)
        .where('accepted', isEqualTo: true)
        .snapshots()
        .listen((event) async {
      if (event.docs.length != length) {
        length = event.docs.length;
        usersList.clear();
        for (var i = 0; i < length; i++) {
          final membershipData = MembershipData.fromJson(event.docs[i].data());
          if (membershipData.userId != applicationState.user!.uid) {
            usersList.add(
              (await context
                  .read<ApplicationState>()
                  .getUserInfo(membershipData.userId))!,
            );
          }
        }
        setState(() {});
      }
    });
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              appLocalizations.users,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        usersList.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${usersList.length}/50',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.start,
                      ),
                    ),
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
                  ...List.generate(
                    usersList.length,
                    (index) => Visibility(
                      visible: usersList[index]
                          .displayName
                          .toLowerCase()
                          .contains(search.toLowerCase()),
                      child: UserSettingsTile(
                        gymData: widget.gymData,
                        localMembershipData: widget.localMembershipData,
                        userData: usersList[index],
                      ),
                    ),
                  )
                ],
              )
            : const NoUsers()
      ],
    );
  }
}
