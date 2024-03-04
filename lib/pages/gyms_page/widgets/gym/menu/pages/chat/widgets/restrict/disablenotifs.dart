import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:provider/provider.dart';

class DisableNotifications extends StatelessWidget {
  final String userId;
  const DisableNotifications({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    final Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection('restrictions')
        .where('userA', isEqualTo: applicationState.user!.uid)
        .where('userB', isEqualTo: userId)
        .snapshots();
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Map<String, dynamic> data = snapshot.data!.docs.isNotEmpty
              ? snapshot.data!.docs[0].data()
              : {
                  'userA': applicationState.user!.uid,
                  'userB': userId,
                  'block': false,
                  'disableNotifications': false,
                };
          final bool notificationsDisabled = data['disableNotifications'];
          return ListTile(
            leading: const Icon(CupertinoIcons.chat_bubble),
            title: Text(notificationsDisabled
                ? appLocalizations.enableNotifications
                : appLocalizations.disableNotifications),
            iconColor: notificationsDisabled ? Colors.green : Colors.red,
            textColor: notificationsDisabled ? Colors.green : Colors.red,
            tileColor: notificationsDisabled
                ? const Color.fromARGB(56, 54, 244, 67)
                : const Color.fromARGB(56, 244, 67, 54),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () {
              showWarningDialog(
                title: appLocalizations.disableNotifications,
                context: context,
                yes: () {
                  applicationState.changeRestrictions(
                    userId,
                    data['block'],
                    !notificationsDisabled,
                  );
                },
              );
            },
          );
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }
}
