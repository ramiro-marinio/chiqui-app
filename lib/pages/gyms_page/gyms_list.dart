import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/gyms_page/widgets/add_gym.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/widgets/gymtile.dart';
import 'package:gymapp/pages/gyms_page/widgets/join_gym/join_gym.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyGyms extends StatefulWidget {
  const MyGyms({super.key});

  @override
  State<MyGyms> createState() => _MyGymsState();
}

class _MyGymsState extends State<MyGyms> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Consumer<ApplicationState>(
      builder: (context, applicationState, child) {
        List<GymData>? gymData = applicationState.gyms;
        return Scaffold(
          drawer: const NavDrawer(),
          appBar: AppBar(
            title: Text(appLocalizations.myGyms),
            actions: [
              AddGymButton(
                onJoinGym: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinGym(),
                    ),
                  );
                },
                onCreateGym: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGym(),
                    ),
                  );
                },
              )
            ],
          ),
          body: Builder(
            builder: (context) {
              if (gymData == null) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return ListView(
                children: [
                  ...List.generate(
                    gymData.length,
                    (index) => GymTile(
                      gymData: gymData[index],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
