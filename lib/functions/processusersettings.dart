import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:provider/provider.dart';

List<UserData> processUserSettings(
    List<UserData> userData, BuildContext context) {
  List<UserData> result = [];
  ApplicationState applicationState = Provider.of<ApplicationState>(context);
  for (UserData user in userData) {
    if (applicationState.user!.uid != user.userId) {
      result += [user];
    }
  }
  return result;
}
