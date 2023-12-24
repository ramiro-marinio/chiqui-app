import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase_options.dart';
import 'package:gymapp/functions/handlemessage.dart';
import 'package:gymapp/navigation/gorouter.dart';
import 'package:gymapp/pages/other/function/handlewifi.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> globalKeyNavState = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  GoRouter goRouter = await getRouter();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: App(
        goRouter: goRouter,
      ),
    ),
  );
  wifiHandler = Connectivity().onConnectivityChanged.listen(handleWifi);
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
}

class App extends StatefulWidget {
  final GoRouter goRouter;
  const App({super.key, required this.goRouter});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: widget.goRouter,
      theme: ThemeData(
        useMaterial3: true,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        fontFamily: 'SansSerif',
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          sliderTheme: const SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
          ),
          fontFamily: 'SansSerif'),
    );
  }
}
