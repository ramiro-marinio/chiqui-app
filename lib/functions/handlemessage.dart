import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/main.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/widgets/chat_page.dart';
import 'package:provider/provider.dart';

void handleMessage(
    RemoteMessage? message, GlobalKey<NavigatorState> key) async {
  BuildContext context = key.currentContext!;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator.adaptive(),
    ),
  );
  ApplicationState applicationState =
      Provider.of<ApplicationState>(context, listen: false);
  if (message == null) {
    return;
  }
  switch (message.data['type']) {
    case 'message':
      String gymId = message.data['gymId'];
      String senderId = message.data['senderId'] as String;
      UserData? sender = await applicationState.getUserInfo(senderId);
      UserData user = UserData.fromJson(
        jsonDecode(message.data['user']) as Map<String, dynamic>,
      );
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(
            gymId: gymId,
            otherUser: sender,
            users: [user],
          ),
        ));
      }
  }
}

void handleMessageForeground(NotificationResponse details) {
  handleMessage(
    RemoteMessage.fromMap(
      jsonDecode(details.payload!),
    ),
    globalKeyNavState,
  );
}
