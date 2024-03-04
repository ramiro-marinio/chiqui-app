import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:provider/provider.dart';

class BlockUser extends StatelessWidget {
  final String userId;
  const BlockUser({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    Stream<QuerySnapshot<Map<String, dynamic>>> restrictionStream =
        FirebaseFirestore.instance
            .collection('restrictions')
            .where('userA', isEqualTo: applicationState.user!.uid)
            .where('userB', isEqualTo: userId)
            .snapshots();
    return StreamBuilder(
      stream: restrictionStream,
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
          final bool blocked = data['block'];
          return ListTile(
            leading: const Icon(CupertinoIcons.nosign),
            title: Text(
                blocked ? appLocalizations.unblock : appLocalizations.block),
            iconColor: blocked ? Colors.green : Colors.red,
            textColor: blocked ? Colors.green : Colors.red,
            tileColor: blocked
                ? const Color.fromARGB(56, 54, 244, 67)
                : const Color.fromARGB(56, 244, 67, 54),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () {
              showWarningDialog(
                title:
                    blocked ? appLocalizations.unblock : appLocalizations.block,
                context: context,
                yes: () {
                  applicationState.changeRestrictions(
                    userId,
                    !blocked,
                    data['disableNotifications'],
                  );
                },
              );
            },
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
