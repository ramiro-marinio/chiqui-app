import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/video_viewer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewDemoDetails extends StatelessWidget {
  final DemonstrationData demonstrationData;
  const ViewDemoDetails({super.key, required this.demonstrationData});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(demonstrationData.exerciseName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                demonstrationData.description == null ||
                        demonstrationData.description!.isEmpty
                    ? appLocalizations.noDescription
                    : demonstrationData.description!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            if (demonstrationData.workAreas.isNotEmpty)
              Text(
                appLocalizations.workAreas,
                style: const TextStyle(fontSize: 30),
              ),
            ...List.generate(
              demonstrationData.workAreas.length,
              (index) => Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: adaptiveColor(
                          const Color.fromARGB(255, 139, 188, 230),
                          const Color.fromARGB(255, 0, 0, 60),
                          context),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(2, 2),
                            color: Color.fromARGB(200, 0, 0, 0))
                      ]),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: SizedBox(
                      child: AutoSizeText(
                        demonstrationData.workAreas[index],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const AdaptiveDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.star),
                ),
                Text(
                  appLocalizations.generalAdvice,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Text(
                (demonstrationData.advice?.isNotEmpty ?? false)
                    ? demonstrationData.advice ?? appLocalizations.noAdvice
                    : appLocalizations.noAdvice,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const AdaptiveDivider(),
            VideoViewer(url: demonstrationData.resourceURL),
          ],
        ),
      ),
    );
  }
}
