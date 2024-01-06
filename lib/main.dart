import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase_options.dart';
import 'package:gymapp/functions/initnotifications.dart';
import 'package:gymapp/l10n/l10n.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:gymapp/navigation/gorouter.dart';
import 'package:gymapp/pages/other/function/handlewifi.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

GlobalKey<NavigatorState> globalKeyNavState = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  GoRouter goRouter = await getRouter();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ApplicationState(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalSettingsState(),
        ),
      ],
      child: App(
        goRouter: goRouter,
      ),
    ),
  );
  wifiHandler = Connectivity().onConnectivityChanged.listen(handleWifi);
  FirebaseMessaging.instance.requestPermission();
  initNotifications();
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
    LocalSettingsState localSettingsState =
        Provider.of<LocalSettingsState>(context);
    Brightness brightness = Brightness.light;
    switch (localSettingsState.theme) {
      case 0:
        brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
      case 1:
        brightness = Brightness.light;
      case 2:
        brightness = Brightness.dark;
    }
    return MaterialApp.router(
      supportedLocales: L10n.all,
      locale: const Locale('pt'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: widget.goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: brightness,
        useMaterial3: true,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
        fontFamily: 'SansSerif',
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
        ),
      ),
    );
  }
}
