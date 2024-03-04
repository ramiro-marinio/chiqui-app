import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({super.key});

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  late TextEditingController titleController;
  late TextEditingController contactsController;
  late TextEditingController bodyController;
  @override
  void initState() {
    super.initState();
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context, listen: false);
    titleController = TextEditingController();
    contactsController =
        TextEditingController(text: applicationState.user!.email);
    bodyController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: Text(appLocalizations.sendSuggestion),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(CupertinoIcons.info),
                    )),
                    TextSpan(
                      children: [
                        TextSpan(
                            style: TextStyle(
                                color: adaptiveColor(
                                    Colors.black, Colors.white, context)),
                            text: appLocalizations.suggestionDetails(
                              'trainguru.online@gmail.com',
                            )),
                        TextSpan(
                          text: 'trainguru.online@gmail.com',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(
                                Uri.parse(
                                  'mailto:ramiro.marinho0@gmail.com?subject=Suggestion&body= ',
                                ),
                              );
                            },
                          style: const TextStyle(color: Colors.lightBlue),
                        )
                      ],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const AdaptiveDivider(
              indent: 8,
              thickness: 0.2,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                appLocalizations.suggestionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  setState(() {});
                },
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: appLocalizations.stHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                appLocalizations.communicationMediums,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: contactsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: appLocalizations.cmHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                appLocalizations.suggestionBody,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: TextField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: appLocalizations.sbHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: titleController.text.isNotEmpty
                  ? () {
                      showDialog(
                        context: context,
                        builder: (_) => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                      FirebaseFirestore.instance.collection('suggestions').add(
                        {
                          'title': titleController.text,
                          'contacts': contactsController.text,
                          'review': bodyController.text,
                          'userID': applicationState.user!.uid,
                          'email': applicationState.user!.email,
                        },
                      ).then((value) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(appLocalizations.suggestionSent),
                          ),
                        );
                        context.go('/');
                      });
                    }
                  : null,
              child: Text(appLocalizations.sendSuggestionButton),
            )
          ],
        ),
      ),
    );
  }
}
