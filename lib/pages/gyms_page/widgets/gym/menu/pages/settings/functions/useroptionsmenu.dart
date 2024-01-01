import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/alertsnackbar.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/widgets/userdetails.dart';
import 'package:gymapp/widgets/icontext.dart';

void showUserOptionsMenu({
  required BuildContext context,
  required TapUpDetails details,
  //could be null because of loading
  required MembershipData? membership,
  required ApplicationState applicationState,
  required MembershipData localMembershipData,
  required GymData gymData,
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
      if ((localMembershipData.admin ||
              gymData.ownerId == localMembershipData.userId) &&
          (!admin! || !coach!) &&
          gymData.ownerId != membership?.userId)
        PopupMenuItem(
          child: IconText(
            icon: const Icon(Icons.fitness_center),
            text: coach != null
                ? (coach ? 'Remove Coach Role' : 'Make Coach')
                : 'Loading...',
          ),
          onTap: () {
            applicationState.modifyMembership({'coach': !coach!}, membership!);
            showAlertSnackbar(
                context: context,
                text: 'Role Changed Succesfully!',
                duration: const Duration(seconds: 1));
          },
        ),
      if ((localMembershipData.admin &&
                  gymData.ownerId != membership?.userId &&
                  !(admin ?? true) ||
              localMembershipData.userId == gymData.ownerId) &&
          gymData.ownerId != membership?.userId)
        PopupMenuItem(
          child: IconText(
            icon: const Icon(Icons.shield),
            text: admin != null
                ? (admin ? 'Remove Admin. Role' : 'Make Administrator')
                : 'Loading...',
          ),
          onTap: () {
            if (admin == false) {
              showWarningDialog(
                title: 'Warning',
                description:
                    'Doing this will turn the user into an admin. Are you sure?',
                context: context,
                yes: () {
                  applicationState
                      .modifyMembership({'admin': !admin!}, membership!);
                  showAlertSnackbar(
                      context: context,
                      text: 'Role Changed Successfully!',
                      duration: const Duration(seconds: 1));
                },
              );
            } else {
              applicationState
                  .modifyMembership({'admin': !admin!}, membership!);
              showAlertSnackbar(
                  context: context,
                  text: 'Role Changed Successfully!',
                  duration: const Duration(seconds: 1));
            }
          },
        ),
      if ((gymData.ownerId == localMembershipData.userId ||
              localMembershipData.admin && !(admin ?? true)) &&
          gymData.ownerId != membership!.userId)
        PopupMenuItem(
          child: const IconText(
            icon: Icon(Icons.do_not_disturb),
            text: 'Kick Out',
          ),
          onTap: () {
            showWarningDialog(
              title: 'Are you sure?',
              context: context,
              yes: () {
                applicationState.kickUser(gymData.id!, userData.userId);
              },
            );
          },
        ),
      PopupMenuItem(
        child: const IconText(
          icon: Icon(Icons.remove_red_eye),
          text: 'View Details',
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetails(
                userData: userData,
              ),
            ),
          );
        },
      )
    ],
  );
}
