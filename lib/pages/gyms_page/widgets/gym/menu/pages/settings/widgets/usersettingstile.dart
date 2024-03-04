import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettingsTile extends StatefulWidget {
  final GymData gymData;
  final MembershipData localMembershipData;
  final UserData userData;
  const UserSettingsTile({
    super.key,
    required this.gymData,
    required this.localMembershipData,
    required this.userData,
  });

  @override
  State<UserSettingsTile> createState() => _UserSettingsTileState();
}

class _UserSettingsTileState extends State<UserSettingsTile> {
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    final UserData user = widget.userData;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('memberships')
          .where('gymId', isEqualTo: widget.gymData.id!)
          .where('userId', isEqualTo: user.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final membershipData =
              MembershipData.fromJson(snapshot.data!.docs[0].data());
          final admin = membershipData.admin;
          final coach = membershipData.coach;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Card(
              color: adaptiveColor(const Color.fromARGB(255, 247, 249, 255),
                  const Color.fromARGB(255, 24, 24, 27), context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                splashColor: const Color.fromARGB(100, 255, 255, 255),
                customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onTapUp: (details) {
                  showUserOptionsMenu(
                    context: context,
                    details: details,
                    membership: membershipData,
                    applicationState: applicationState,
                    localMembershipData: widget.localMembershipData,
                    gymData: widget.gymData,
                    userData: user,
                  );
                },
                child: ListTile(
                  title: AutoSizeText(
                    user.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : const AssetImage('assets/no_image.jpg')
                            as ImageProvider,
                  ),
                  subtitle: Row(
                    children: [
                      user.info.isNotEmpty
                          ? Expanded(
                              child: Text(
                              user.info,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))
                          : Text(appLocalization.noInfo),
                      Visibility(
                        visible: coach,
                        child: const Icon(Icons.fitness_center),
                      ),
                      Visibility(
                        visible: admin,
                        child: const Icon(Icons.shield),
                      ),
                      SizedBox(
                        width: 80,
                        child: Column(
                          children: [
                            Icon(user.sex ? Icons.female : Icons.male),
                            SizedBox(
                              width: 70,
                              child: AutoSizeText(
                                user.sex
                                    ? appLocalization.female
                                    : appLocalization.male,
                                minFontSize: 1,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        appLocalization.age(
                          calculateAge(user.birthday),
                        ),
                      ),
                    ],
                  ),
                ),
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
}
