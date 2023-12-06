import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/exercisedemo.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/demomaker.dart';
import 'package:provider/provider.dart';

class ExerciseDemonstrations extends StatefulWidget {
  final GymData gymData;
  const ExerciseDemonstrations({
    super.key,
    required this.gymData,
  });

  @override
  State<ExerciseDemonstrations> createState() => _ExerciseDemonstrationsState();
}

class _ExerciseDemonstrationsState extends State<ExerciseDemonstrations> {
  Widget? page;
  List<DemonstrationData> demoData = [];
  List<Widget>? result;
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      Future<List<Map<String, dynamic>>> data =
          applicationState.getDemoData(widget.gymData.id!);

      return FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            result = List.generate(
                snapshot.data!.length,
                (index) => ExerciseDemo(
                    demoData:
                        DemonstrationData.fromJson(snapshot.data![index])));
            return ListView(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        "Exercises",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                ...result!,
                Visibility(
                  visible: applicationState.user!.uid == widget.gymData.ownerId,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DemoMaker(
                                gymId: widget.gymData.id!,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_circle),
                        color: Colors.green,
                      ),
                    ],
                  ),
                )
              ],
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
    });
  }
}
