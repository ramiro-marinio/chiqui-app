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
import 'package:gymapp/firebase/widgets/profile_config/bodyfield.dart';
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
    if (user == null) {
      return const MustBeLoggedIn();
    }
    if (userData == null) {
      return const Scaffold(
        body: Center(
            child: Text(
          'Error',
          style: TextStyle(fontSize: 30, color: Colors.red),
        )),
      );
    }
    UserData newUserData = UserData(
      userId: user.uid,
      info: userData.info,
      sex: userData.sex,
      birthDay: userData.birthDay,
      staff: userData.staff,
      displayName: userData.displayName,
      photoURL: userData.photoURL,
      stature: userData.stature,
      weight: userData.weight,
      injuries: userData.injuries,
    );
    return WillPopScope(
      onWillPop: () async {
        if (!mapEquals(userData.toMap(), newUserData.toMap()) ||
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
              Field(
                icon: const Icon(Icons.person),
                title: "Display Name",
                initialText: displayName,
                onChanged: (value) {
                  displayName = value;
                  newUserData.displayName = value;
                },
                maxLength: 40,
              ),
              Field(
                title: "User Info",
                icon: const Icon(Icons.info),
                initialText: newUserData.info,
                onChanged: (value) {
                  newUserData.info = value;
                },
                maxLength: 200,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
                child: Column(
                  children: [
                    Text(
                      'Training Information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Only the gym staff will see this, in order to deliver an appropriate training routine.',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              SwitchField(
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
              BodyField(
                initialStature: newUserData.stature,
                initialWeight: newUserData.weight,
                setStature: (value) {
                  newUserData.stature = value;
                },
                setWeight: (value) {
                  newUserData.weight = value;
                },
              ),
              const AdaptiveDivider(),
              Field(
                title: 'History',
                initialText: newUserData.injuries,
                icon: const Icon(Icons.personal_injury),
                onChanged: (value) {
                  newUserData.injuries = value;
                },
                maxLines: 6,
                maxLength: 4000,
                hintText:
                    'Previous injuries that make certain exercises painful or dangerous.',
              )
            ],
          ),
        ),
      ),
    );
  }
}
