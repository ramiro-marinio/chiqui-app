import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/choosevaluedialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/invite/lengthinputdialog.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/widgets/infobutton.dart';
import 'package:provider/provider.dart';

class InviteSettings extends StatefulWidget {
  final GymData gymData;
  const InviteSettings({super.key, required this.gymData});

  @override
  State<InviteSettings> createState() => _InviteSettingsState();
}

class _InviteSettingsState extends State<InviteSettings> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    Future<InviteData?> inviteData =
        applicationState.getInviteData(widget.gymData.id!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Code'),
        actions: const [
          InfoButton(
            icon: Icon(Icons.warning),
            title: 'Warning',
            description:
                'It is recommended that you change this code periodically and avoid sharing it excessively, as it could result in your gym being raided by malicious users.',
          )
        ],
      ),
      body: FutureBuilder(
          future: inviteData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              InviteData? inviteData = snapshot.data;
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Invite code:',
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          inviteData?.code ?? 'Error',
                          style: const TextStyle(fontSize: 20),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: inviteData?.code.contains(' ') ?? false,
                    child: const InfoButton(
                      icon: Icon(Icons.warning),
                      title: 'Warning',
                      description:
                          'This code contains spaces, which can lead to confusion when your users enter the code. Try changing the code to not include spaces.',
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
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
                            setState(() {});
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.question_mark),
                    label: const Text('Randomize'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ChooseValueDialog(
                          gymData: widget.gymData,
                          setState: setState,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Pick Manually'),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }),
    );
  }
}
