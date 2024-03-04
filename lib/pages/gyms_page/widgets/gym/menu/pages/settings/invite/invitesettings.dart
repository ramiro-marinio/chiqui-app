import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/choosevaluedialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/lengthinputdialog.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/widgets/infobutton.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteSettings extends StatefulWidget {
  final GymData gymData;
  const InviteSettings({super.key, required this.gymData});

  @override
  State<InviteSettings> createState() => _InviteSettingsState();
}

class _InviteSettingsState extends State<InviteSettings> {
  late ApplicationState applicationState;
  late Future<InviteData?> inviteData;
  MembershipData? membershipData;
  @override
  void initState() {
    super.initState();
    applicationState = Provider.of<ApplicationState>(context, listen: false);
    inviteData = applicationState.getInviteData(widget.gymData.id!);
    applicationState
        .getMembership(widget.gymData.id!, applicationState.user!.uid)
        .then(
          (value) => membershipData = value,
        );
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    bool canChange = applicationState.user!.uid == widget.gymData.ownerId ||
        membershipData?.admin == true;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.inviteCode),
        actions: [
          InfoButton(
            icon: const Icon(Icons.warning),
            title: appLocalizations.warning,
            description: appLocalizations.inviteCodeWarningDetails,
          )
        ],
      ),
      body: FutureBuilder(
          future: inviteData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              InviteData? result = snapshot.data;
              return Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appLocalizations.inviteCode,
                          style: const TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            result?.code ?? 'Error',
                            style: const TextStyle(fontSize: 20),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: result?.code.contains(' ') ?? false,
                    child: InfoButton(
                      icon: const Icon(Icons.warning),
                      title: appLocalizations.warning,
                      description: appLocalizations.codeWithSpaces,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: canChange
                            ? () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => LengthInputDialog(
                                    chars: 7,
                                    onComplete: (val) async {
                                      await applicationState.updateInviteData(
                                        InviteData(
                                          code: generateRandomString(val),
                                          gymId: widget.gymData.id!,
                                        ),
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      setState(() {
                                        inviteData = applicationState
                                            .getInviteData(widget.gymData.id!);
                                      });
                                    },
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.question_mark),
                        label: Text(appLocalizations.randomizeInviteCode),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: canChange
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ChooseValueDialog(
                                    gymData: widget.gymData,
                                    setState: setState,
                                    whenComplete: () {
                                      inviteData = applicationState
                                          .getInviteData(widget.gymData.id!);
                                    },
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.edit),
                        label: Text(appLocalizations.pickManually),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }),
    );
  }
}
