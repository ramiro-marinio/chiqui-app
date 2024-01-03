import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/userdetails.dart';
import 'package:gymapp/widgets/zoomavatar.dart';

class ChatOptions extends StatefulWidget {
  final UserData? userData;
  final Future<MembershipData?> membership;
  const ChatOptions({
    super.key,
    required this.userData,
    required this.membership,
  });

  @override
  State<ChatOptions> createState() => _ChatOptionsState();
}

class _ChatOptionsState extends State<ChatOptions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.membership,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const Text('Error');
            }
            final MembershipData membershipData = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Options'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            ZoomAvatar(
                              photoURL: widget.userData?.photoURL,
                              radius: 80,
                              tag: 'Chat-Pic',
                            ),
                            Text(
                              widget.userData?.displayName ?? 'Public Chat',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 25),
                            ),
                            const AdaptiveDivider(
                              indent: 8,
                            ),
                            const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Information',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  widget.userData?.info ?? 'No information',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  membershipData.admin || membershipData.coach,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return UserDetails(
                                          userData: widget.userData!,
                                        );
                                      },
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.fitness_center),
                                label: const Text(
                                  'Get Training Information',
                                ),
                              ),
                            ),
                            const AdaptiveDivider(
                              indent: 8,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        });
  }
}
