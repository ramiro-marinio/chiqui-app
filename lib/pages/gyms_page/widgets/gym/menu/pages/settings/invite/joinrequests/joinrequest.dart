import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/widgets/crawl.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinRequest extends StatelessWidget {
  final String docId;
  final MembershipData membershipData;
  final String search;
  final bool enabled;
  const JoinRequest(
      {super.key,
      required this.membershipData,
      required this.docId,
      required this.search,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    Future<UserData?> userInfo =
        applicationState.getUserInfo(membershipData.userId);
    return FutureBuilder(
        future: userInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            if (userData == null) {
              return const Text('Error Loading');
            }
            return Visibility(
              visible: userData.displayName.contains(search),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: ZoomAvatar(
                              photoURL: userData.photoURL,
                              radius: 20,
                              gymImage: false,
                              tag: UniqueKey().toString(),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Crawl(
                                child: Text(
                                  userData.displayName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: enabled
                                      ? () {
                                          FirebaseFirestore.instance
                                              .collection('memberships')
                                              .doc(docId)
                                              .update(
                                            {'accepted': true},
                                          );
                                        }
                                      : null,
                                  child: Text(appLocalizations.accept),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('memberships')
                                        .doc(docId)
                                        .delete();
                                  },
                                  child: Text(appLocalizations.reject),
                                )
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }
}
