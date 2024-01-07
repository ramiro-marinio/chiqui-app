import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return FutureBuilder(
      future: creatorData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ZoomAvatar(
                    photoURL: widget.gymData.photoURL,
                    radius: 72,
                    tag: 'InfoPic',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.gymData.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.gymData.description!,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${appLocalizations.owner} ${snapshot.data?.displayName ?? 'unknown'}',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
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
