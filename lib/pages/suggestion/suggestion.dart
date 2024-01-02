import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({super.key});

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    final titleController = TextEditingController();
    final contactsController =
        TextEditingController(text: applicationState.user!.email);
    final bodyController = TextEditingController();
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Send a suggestion'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Send a suggestion',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    const WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.info),
                    )),
                    TextSpan(
                      children: [
                        const TextSpan(
                            text:
                                'Suggestions help us make our application better in all aspects. If you believe that you have constructive advice for us, don\'t hesitate on writing to us through this option. If you prefer using an email, write to '),
                        TextSpan(
                          text: 'ramiro.marinho0@gmail.com',
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
            const Text(
              'Suggestion Title',
              style: TextStyle(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const Text(
              'Communication Mediums',
              style: TextStyle(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: contactsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'An Email or a Phone Number, for us to reply',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const Text(
              'Suggestion Body',
              style: TextStyle(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: TextField(
                  controller: bodyController,
                  minLines: 4,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Your suggestion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
                    const SnackBar(
                      content: Text('Suggestion sent successfully!'),
                    ),
                  );
                  context.go('/');
                });
              },
              child: const Text('Send Suggestion'),
            )
          ],
        ),
      ),
    );
  }
}
