import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/functions/handlemessage.dart';
import 'package:gymapp/main.dart';
import 'package:provider/provider.dart';

void initNotifications() async {
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      handleMessage(value, globalKeyNavState);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    handleMessage(event, globalKeyNavState);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    handleMessage(message, globalKeyNavState);
  });
  initLocalNotifications();
}

void initLocalNotifications() async {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const iOSIs = DarwinInitializationSettings();
  const androidIs = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidIs, iOS: iOSIs);
  await localNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: handleMessageForeground,
    onDidReceiveBackgroundNotificationResponse: handleMessageForeground,
  );
  const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Channel',
    importance: Importance.high,
  );

  FirebaseMessaging.onMessage.listen(
    (event) {
      final RemoteNotification? notification = event.notification;
      if (notification == null) {
        return;
      }
      ApplicationState applicationState = Provider.of<ApplicationState>(
          globalKeyNavState.currentContext!,
          listen: false);
      if (applicationState.currentChatID != event.data['senderId']) {
        localNotificationsPlugin.show(
          event.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(event.toMap()),
        );
      }
    },
  );
}
