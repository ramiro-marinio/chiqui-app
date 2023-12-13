import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/settings/invite/invitesettings.dart';
import 'package:gymapp/pages/gyms_page/settings/widgets/option.dart';
import 'package:gymapp/pages/gyms_page/settings/widgets/usersettingstile.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final GymData gymData;
  const SettingsPage({super.key, required this.gymData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    final Future<List<UserData?>> users =
        applicationState.getGymUsers(widget.gymData.id!);
    return FutureBuilder(
      future: users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: Column(
              children: [
                Option(
                  icon: const Icon(Icons.group_add),
                  text: 'Invite Code',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InviteSettings(
                          gymData: widget.gymData,
                        ),
                      ),
                    );
                  },
                ),
                Option(
                  icon: const Icon(Icons.edit),
                  text: 'Edit Gym Info',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateGym(editGym: widget.gymData),
                      ),
                    );
                  },
                ),
                ...List.generate(
                    snapshot.data!.length,
                    (index) =>
                        UserSettingsTile(userData: snapshot.data![index]!)),
              ],
            ),
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
