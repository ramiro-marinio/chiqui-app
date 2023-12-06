import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:provider/provider.dart';

class ChooseValueDialog extends StatefulWidget {
  final GymData gymData;
  final Function(Function()) setState;
  const ChooseValueDialog(
      {super.key, required this.gymData, required this.setState});

  @override
  State<ChooseValueDialog> createState() => _ChooseValueDialogState();
}

class _ChooseValueDialogState extends State<ChooseValueDialog> {
  bool working = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String error = '';
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    return AlertDialog(
      title: const Text('Type the desired code'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  errorText: error.isNotEmpty ? error : null,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: !working
                    ? () async {
                        if (controller.text.length < 7) {
                          setState(() {
                            error = 'Code must be at least 7 characters long.';
                            return;
                          });
                        } else {
                          setState(() {
                            working = true;
                          });
                          bool approved = await applicationState
                              .verifyInvite(controller.text);
                          if (!approved) {
                            setState(() {
                              error = 'Code is already used by another gym.';
                              setState(() {
                                working = false;
                              });
                            });
                          } else {
                            await applicationState.updateInviteData(
                              InviteData(
                                  code: controller.text,
                                  gymId: widget.gymData.id!),
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            widget.setState(() {});
                          }
                        }
                      }
                    : null,
                child: !working
                    ? const Text('Submit')
                    : const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator.adaptive(),
                      ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
