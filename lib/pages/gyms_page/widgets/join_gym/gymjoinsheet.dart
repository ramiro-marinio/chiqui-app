import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/invitedata.dart';
import 'package:gymapp/functions/showinfodialog.dart';
import 'package:gymapp/widgets/crawltext.dart';
import 'package:provider/provider.dart';

class GymJoinSheet extends StatefulWidget {
  final InviteData inviteData;
  const GymJoinSheet({super.key, required this.inviteData});

  @override
  State<GymJoinSheet> createState() => _GymJoinSheetState();
}

class _GymJoinSheetState extends State<GymJoinSheet> {
  Future<GymData?>? gymData;
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    gymData ??= applicationState.getGymData(widget.inviteData.gymId);
    return SizedBox(
      height: 400,
      width: double.infinity,
      child: FutureBuilder(
          future: gymData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              GymData? gymData = snapshot.data;
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Is this the correct gym?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 72,
                    backgroundImage: gymData?.photoURL != null
                        ? NetworkImage(gymData!.photoURL!)
                        : const AssetImage('assets/no_image_gym.jpg')
                            as ImageProvider,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CrawlText(
                      text: gymData?.name ?? 'Error',
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (!applicationState.checkMembership(gymData!.id!)) {
                        applicationState.joinGym(FirebaseFirestore.instance
                            .collection('gyms')
                            .doc(gymData.id));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        showInfoDialog(
                          title: 'Already Joined',
                          description: 'You already joined this gym!',
                          context: context,
                        );
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('YES'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('NO'),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
    );
  }
}
