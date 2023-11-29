import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/firebase/widgets/mustbeloggedin.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/birthdayfield.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/field.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/genderfield.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/profilepicpicker.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:provider/provider.dart';

class ProfileConfig extends StatefulWidget {
  const ProfileConfig({super.key});

  @override
  State<ProfileConfig> createState() => _ProfileConfigState();
}

class _ProfileConfigState extends State<ProfileConfig> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = context.read<ApplicationState>();
    User? user = applicationState.user;
    String? displayName = user?.displayName;
    UserData? userData = applicationState.userData;
    UserData newUserData = UserData(
      userId: user?.uid ?? "",
      info: userData?.info ?? "",
      sex: userData?.sex ?? true,
      birthDay: userData?.birthDay ?? DateTime.now(),
      staff: userData?.staff ?? false,
    );
    if (user == null) {
      return const MustBeLoggedIn();
    }
    return WillPopScope(
      onWillPop: () async {
        if (!mapEquals(userData?.toMap(), newUserData.toMap()) ||
            displayName != user.displayName) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const AlertDialog(
                title: Text("Saving changes..."),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              );
            },
          );
          try {
            await user.updateDisplayName(displayName);
            await applicationState.updateUserData(newUserData.toMap());
            if (context.mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color:
                            adaptiveColor(Colors.white, Colors.black, context),
                      ),
                      const Text("Updated Successfully!")
                    ],
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Check your internet connection.")));
            }
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Configure Profile")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProfilePicPicker()],
              ),
              const AdaptiveDivider(),
              Field(
                icon: const Icon(Icons.person),
                title: "Display Name",
                initialText: displayName,
                onChanged: (value) {
                  displayName = value;
                },
              ),
              const AdaptiveDivider(),
              Field(
                title: "User Info",
                icon: const Icon(Icons.info),
                initialText: newUserData.info,
                onChanged: (value) {
                  newUserData.info = value;
                },
              ),
              const AdaptiveDivider(),
              GenderField(
                value: newUserData.sex,
                onChange: (value) {
                  newUserData.sex = !newUserData.sex;
                },
              ),
              const AdaptiveDivider(),
              BirthDayField(
                dateTime: newUserData.birthDay,
                onChangeDatetime: (dateTime) {
                  newUserData.birthDay = dateTime;
                },
              ),
              const AdaptiveDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
