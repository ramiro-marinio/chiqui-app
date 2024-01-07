import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsState extends ChangeNotifier {
  Locale? _osLang;
  Locale get osLang => _osLang ?? const Locale('en');

  Locale _language = const Locale('en');
  Locale get language => _language;

  set language(Locale? value) {
    sharedPreferences.setString('language', value?.languageCode ?? 'os').then(
      (success) {
        if (success) {
          _language = value ?? _osLang!;
          notifyListeners();
        }
      },
    );
  }

  bool _loading = true;
  bool get loading => _loading;
  late SharedPreferences sharedPreferences;
  int _theme = 0;
  set theme(int value) {
    sharedPreferences.setInt('theme', value).then(
      (success) {
        if (success) {
          _theme = value;
          notifyListeners();
        }
      },
    );
  }

  int get theme => _theme;

  bool _metricUnit = true;
  set metricUnit(bool value) {
    _metricUnit = value;
    notifyListeners();
  }

  bool get metricUnit => _metricUnit;

  bool _notificationsAllowed = false;
  bool get notificationsAllowed => _notificationsAllowed;
  set notificationsAllowed(bool value) {
    _notificationsAllowed = value;
    notifyListeners();
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final langCode = sharedPreferences.getString('language');
    if (langCode == null || langCode == 'os') {
      _language =
          Locale((await Devicelocale.currentLocale)?.substring(0, 2) ?? 'en');
    } else {
      _language = Locale(langCode);
    }
    _theme = sharedPreferences.getInt('theme') ?? 0;
    _metricUnit = sharedPreferences.getBool('metricUnit') ?? true;
    _notificationsAllowed = await Permission.notification.isGranted;
  }

  LocalSettingsState() {
    init().then((_) {
      _loading = false;
      notifyListeners();
    });
  }
}
