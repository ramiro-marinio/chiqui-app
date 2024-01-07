import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/userdetails.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatOptions extends StatefulWidget {
  final UserData? userData;
  final Future<MembershipData?> membership;
  final Future<GymData?> gymData;
  const ChatOptions({
    super.key,
    required this.userData,
    required this.membership,
    required this.gymData,
  });

  @override
  State<ChatOptions> createState() => _ChatOptionsState();
}

class _ChatOptionsState extends State<ChatOptions> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: Future.wait([widget.membership, widget.gymData]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Text('Error');
          }
          final MembershipData membershipData =
              snapshot.data![0]! as MembershipData;
          final GymData? gymData = snapshot.data![1] as GymData?;
          return Scaffold(
            appBar: AppBar(
              title: Text(appLocalizations.options),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        children: [
                          ZoomAvatar(
                            photoURL: widget.userData?.photoURL,
                            radius: 80,
                            tag: 'Chat-Pic',
                          ),
                          Text(
                            widget.userData?.displayName ?? 'Public Chat',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25),
                          ),
                          const AdaptiveDivider(
                            indent: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                appLocalizations.information,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                widget.userData?.info ??
                                    appLocalizations.noInfo,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: membershipData.admin ||
                                membershipData.coach ||
                                gymData?.ownerId == membershipData.userId,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UserDetails(
                                            userData: widget.userData!,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.fitness_center),
                                  label: Text(
                                    appLocalizations.viewTrainingInfo,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const AdaptiveDivider(
                            indent: 8,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ListTile(
                            leading: const Icon(Icons.do_not_disturb),
                            title: Text(appLocalizations.block),
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            tileColor: const Color.fromARGB(56, 244, 67, 54),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onTap: () {},
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          ListTile(
                            leading: const Icon(Icons.message),
                            title: Text(appLocalizations.disableNotifications),
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            tileColor: const Color.fromARGB(56, 244, 67, 54),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }
}
