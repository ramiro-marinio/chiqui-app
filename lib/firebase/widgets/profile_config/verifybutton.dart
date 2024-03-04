import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:provider/provider.dart';

class VerifyButton extends StatefulWidget {
  const VerifyButton({super.key});

  @override
  State<VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<VerifyButton> {
  bool alreadySent = false;
  @override
  Widget build(BuildContext context) {
    final applicationState = Provider.of<ApplicationState>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                color: adaptiveColor(Colors.black, Colors.white, context),
              ),
              children: const [
                WidgetSpan(
                  child: Icon(CupertinoIcons.exclamationmark_triangle),
                ),
                TextSpan(text: 'Your Email has not been verified!'),
              ],
            ),
          ),
        ),
        const Text('Click the button below to send a verification email.'),
        ElevatedButton(
          onPressed: !alreadySent
              ? () {
                  applicationState.user!.sendEmailVerification();
                  setState(() {
                    alreadySent = true;
                  });
                }
              : null,
          child: const Text('Send'),
        ),
      ],
    );
  }
}
