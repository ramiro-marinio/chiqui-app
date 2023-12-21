import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/alertsnackbar.dart';
import 'package:gymapp/functions/showwarningdialog.dart';

void showUserOptionsMenu({
  required BuildContext context,
  required TapUpDetails details,
  required MembershipData? membership,
  required ApplicationState applicationState,
  required MembershipData localMembershipData,
  required String gymId,
  required UserData userData,
}) {
  bool? coach = membership?.coach;
  bool? admin = membership?.admin;
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
          child: Text(coach != null
              ? (coach ? 'Remove Coach Role' : 'Make Coach')
              : 'Loading...'),
          onTap: () {
            applicationState.modifyMembership({'coach': !coach!}, membership!);
            showAlertSnackbar(
                context: context,
                text: 'Role Changed Succesfully!',
                duration: const Duration(seconds: 1));
          },
        ),
        PopupMenuItem(
          child: Text(admin != null
              ? (admin ? 'Remove Administrator Role' : 'Make Administrator')
              : 'Loading...'),
          onTap: () {
            applicationState.modifyMembership({'admin': !admin!}, membership!);
            showAlertSnackbar(
                context: context,
                text: 'Role Changed Successfully!',
                duration: const Duration(seconds: 1));
          },
        ),
        PopupMenuItem(
          child: const Text('Kick Out'),
          onTap: () {
            showWarningDialog(
              title: 'Are you sure?',
              context: context,
              yes: () {
                applicationState.kickUser(gymId, userData.userId);
              },
            );
          },
        )
      ]);
}
