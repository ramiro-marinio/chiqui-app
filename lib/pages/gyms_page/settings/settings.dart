import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/settings/invite/invitesettings.dart';

class SettingsPage extends StatefulWidget {
  final GymData gymData;
  const SettingsPage({super.key, required this.gymData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text('Invite Code'),
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
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Admin Panel'),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
