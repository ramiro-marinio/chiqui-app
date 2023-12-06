import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/chat/widgets/messagecard.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/chat/widgets/messagetyper.dart';
import 'package:provider/provider.dart';

class MyChats extends StatefulWidget {
  final GymData gymData;
  const MyChats({super.key, required this.gymData});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  Future<List<UserData?>>? users;
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    users ??= applicationState.getGymUsers(widget.gymData.id!);
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    MessageCard(
                      uid: applicationState.user!.uid,
                      message:
                          'Lorem ipsum dolor sit amet consectetur adiscipit elit nigga',
                      users: snapshot.data!,
                    ),
                    MessageCard(
                      uid: 'nigger',
                      message: 'Hello, my name is John',
                      users: snapshot.data!,
                    ),
                  ],
                ),
              ),
              const AdaptiveDivider(
                indent: 0,
                thickness: 0.2,
              ),
              MessageTyper(
                onSubmit: (value) {},
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
