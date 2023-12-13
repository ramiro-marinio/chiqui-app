import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/widgets/icontext.dart';
import 'package:gymapp/widgets/crawltext.dart';

class UserSettingsTile extends StatelessWidget {
  final UserData userData;
  const UserSettingsTile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTapUp: (details) {
          showMenu(
              context: context,
              position: RelativeRect.fromDirectional(
                  textDirection: TextDirection.ltr,
                  start: details.globalPosition.dx,
                  top: details.globalPosition.dy,
                  end: details.globalPosition.dx,
                  bottom: details.globalPosition.dy),
              items: [
                PopupMenuItem(
                  child: const IconText(
                      icon: Icon(Icons.shield), text: 'Make Coach'),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const IconText(
                      icon: Icon(Icons.do_not_disturb), text: 'Kick Out'),
                  onTap: () {},
                )
              ]);
        },
        child: ListTile(
          title: Text(userData.displayName),
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: userData.photoURL != null
                ? NetworkImage(userData.photoURL!)
                : const AssetImage('assets/no_image.jpg') as ImageProvider,
          ),
          subtitle: userData.info.isNotEmpty
              ? Crawl(
                  child: Text(
                  userData.info.replaceAll(RegExp(r'\n'), ''),
                  style: const TextStyle(fontSize: 14),
                ))
              : const Text('No info'),
        ),
      ),
    );
  }
}
