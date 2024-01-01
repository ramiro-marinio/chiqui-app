import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:provider/provider.dart';

class GymInfo extends StatefulWidget {
  final GymData gymData;
  const GymInfo({super.key, required this.gymData});

  @override
  State<GymInfo> createState() => _GymInfoState();
}

class _GymInfoState extends State<GymInfo> {
  late final Future<UserData?> creatorData;
  @override
  void initState() {
    super.initState();
    ApplicationState applicationState = context.read<ApplicationState>();
    creatorData = applicationState.getUserInfo(widget.gymData.ownerId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: creatorData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Information',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                  ),
                ),
                const AdaptiveDivider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Gym Name:${widget.gymData.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
                const Text(
                  'Description:',
                  style: TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.gymData.description!,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const AdaptiveDivider(),
                Text(
                  'Owner: ${snapshot.data?.displayName ?? 'unknown'}',
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
          );
        } else {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
            ],
          );
        }
      },
    );
  }
}
