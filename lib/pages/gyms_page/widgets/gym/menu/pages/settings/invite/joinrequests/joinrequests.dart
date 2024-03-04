import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/joinrequests/joinrequest.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/nousers.dart';
import 'package:gymapp/widgets/filterbar.dart';

class JoinRequests extends StatefulWidget {
  final GymData gymData;
  const JoinRequests({super.key, required this.gymData});

  @override
  State<JoinRequests> createState() => _JoinRequestsState();
}

class _JoinRequestsState extends State<JoinRequests> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> toBeAccepted = FirebaseFirestore
        .instance
        .collection('memberships')
        .where('gymId', isEqualTo: widget.gymData.id)
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.joinRequests),
        ),
        body: StreamBuilder(
          stream: toBeAccepted,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<MembershipData> data = [];
              int members = 0;
              for (var doc in snapshot.data!.docs) {
                final membershipData = MembershipData.fromJson(doc.data());
                if (!membershipData.accepted) {
                  data += [membershipData];
                } else {
                  members++;
                }
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        '$members/50',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  FilterBar(
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                  Expanded(
                    child: ListView(
                      children: data.isNotEmpty
                          ? List.generate(
                              data.length,
                              (index) => JoinRequest(
                                search: search,
                                docId: snapshot.data!.docs[index].id,
                                membershipData: data[index],
                                enabled: members < 50,
                              ),
                            )
                          : const [NoUsers()],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ));
  }
}
