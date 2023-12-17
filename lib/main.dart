import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase_options.dart';
import 'package:gymapp/functions/handlemessage.dart';
import 'package:gymapp/navigation/gorouter.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> fuckinKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: const App(),
    ),
  );
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.getInitialMessage().then((value) {
    if (value != null) {
      handleMessage(value, fuckinKey);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    handleMessage(event, fuckinKey);
  });
  FirebaseMessaging.onBackgroundMessage((message) async {
    handleMessage(message, fuckinKey);
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      theme: ThemeData(
          useMaterial3: true,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
            ),
          ),
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          )),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
      ),
    );
  }
}
