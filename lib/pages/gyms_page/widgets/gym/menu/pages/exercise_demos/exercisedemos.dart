import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/exercisedemo.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/demomaker.dart';
import 'package:gymapp/widgets/filterbar.dart';
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
  String search = '';
  Widget? page;
  List<DemonstrationData> demoData = [];
  List<Widget>? result;
  MembershipData? membershipData;
  @override
  void initState() {
    super.initState();
    ApplicationState applicationState = Provider.of<ApplicationState>(
      context,
      listen: false,
    );
    applicationState
        .getMembership(widget.gymData.id!, applicationState.user!.uid)
        .then(
          (value) => setState(
            () {
              membershipData = value;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      Future<List<Map<String, dynamic>>> data =
          applicationState.getDemoData(widget.gymData.id!);

      return StatefulBuilder(builder: (context, setState) {
        return FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              result = List<Widget>.generate(
                snapshot.data!.length,
                (index) => Visibility(
                  visible: DemonstrationData.fromJson(snapshot.data![index])
                      .exerciseName
                      .contains(search),
                  child: ExerciseDemo(
                    demoData: DemonstrationData.fromJson(snapshot.data![index]),
                    gymData: widget.gymData,
                    canEdit:
                        applicationState.user!.uid == widget.gymData.ownerId ||
                            membershipData?.admin == true ||
                            membershipData?.coach == true,
                  ),
                ),
              );
              return Scaffold(
                body: ListView(
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
                    FilterBar(
                      onChanged: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                    ),
                    ...result ?? [],
                  ],
                ),
                floatingActionButton: Visibility(
                  visible:
                      applicationState.user!.uid == widget.gymData.ownerId ||
                          membershipData?.admin == true ||
                          membershipData?.coach == true,
                  child: Tooltip(
                    message: 'Add Demonstration',
                    child: FloatingActionButton(
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
                      child: const Icon(Icons.add),
                    ),
                  ),
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
      });
    });
  }
}
