import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsState extends ChangeNotifier {
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
    metricUnit = value;
  }

  bool get metricUnit => _metricUnit;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    _theme = sharedPreferences.getInt('theme') ?? 0;
    _metricUnit = sharedPreferences.getBool('metricUnit') ?? true;
  }

  LocalSettingsState() {
    init().then((_) {
      _loading = false;
      notifyListeners();
    });
  }
}
