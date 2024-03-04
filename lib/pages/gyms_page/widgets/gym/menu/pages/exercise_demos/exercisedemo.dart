import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/demomaker.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/viewdemodetails.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:gymapp/widgets/crawl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExerciseDemo extends StatelessWidget {
  final DemonstrationData demoData;
  final GymData gymData;
  final bool canEdit;
  const ExerciseDemo(
      {super.key,
      required this.demoData,
      required this.gymData,
      required this.canEdit});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      return Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Crawl(
                      child: Text(
                        demoData.exerciseName,
                      ),
                    )),
                Visibility(
                  visible: canEdit,
                  child: Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DemoMaker(
                                      gymId: gymData.id!, editData: demoData),
                                ));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            showWarningDialog(
                              title: appLocalizations.deleteDemoPrompt,
                              context: context,
                              yes: () {
                                context
                                    .read<ApplicationState>()
                                    .deleteDemonstration(demoData);
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ViewDemoDetails(demonstrationData: demoData),
                ),
              );
            },
          ),
          const AdaptiveDivider(
            thickness: 0.2,
            indent: 8,
          ),
        ],
      );
    });
  }
}
