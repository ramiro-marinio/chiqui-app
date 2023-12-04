import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/video_viewer.dart';

class ViewDemoDetails extends StatelessWidget {
  final DemonstrationData demonstrationData;
  const ViewDemoDetails({super.key, required this.demonstrationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(demonstrationData.exerciseName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            Text(demonstrationData.description == null ||
                    demonstrationData.description!.isEmpty
                ? "No description"
                : demonstrationData.description!),
            const AdaptiveDivider(),
            const Text(
              'Work Areas:',
              style: TextStyle(fontSize: 30),
            ),
            ...List.generate(
              demonstrationData.workAreas.length,
              (index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: SizedBox(
                      width: 70,
                      child: AutoSizeText(
                        demonstrationData.workAreas[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const AdaptiveDivider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.star),
                ),
                Text(
                  'General Advice',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Text(
              (demonstrationData.advice?.isNotEmpty ?? false)
                  ? demonstrationData.advice ?? 'No Information'
                  : 'No Information',
              style: const TextStyle(fontSize: 20),
            ),
            const AdaptiveDivider(),
            VideoViewer(url: demonstrationData.resourceURL),
          ],
        ),
      ),
    );
  }
}
