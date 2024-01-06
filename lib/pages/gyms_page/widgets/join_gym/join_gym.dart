import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/functions/showinfodialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/join_gym/gymjoinsheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinGym extends StatefulWidget {
  const JoinGym({super.key});

  @override
  State<JoinGym> createState() => _JoinGymState();
}

class _JoinGymState extends State<JoinGym> {
  String code = '';
  bool working = false;
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = context.read<ApplicationState>();
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.joinGym),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  code = value;
                });
              },
              decoration: InputDecoration(
                hintText: appLocalizations.inviteCode,
              ),
              maxLength: 25,
            ),
          ),
          ElevatedButton(
            onPressed: code.isNotEmpty && !working
                ? () async {
                    setState(() {
                      working = true;
                    });
                    InviteData? inviteData =
                        await applicationState.getInviteDataByCode(code);
                    setState(() {
                      working = false;
                    });
                    if (context.mounted) {
                      if (inviteData == null) {
                        await showInfoDialog(
                            title: appLocalizations.notFound,
                            description: appLocalizations.nfDetails,
                            context: context);
                      } else {
                        await showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                GymJoinSheet(inviteData: inviteData));
                      }
                    }
                  }
                : null,
            child: working
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Text(appLocalizations.joinButton),
          ),
        ],
      ),
    );
  }
}
