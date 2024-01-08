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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileConfig extends StatefulWidget {
  const ProfileConfig({super.key});

  @override
  State<ProfileConfig> createState() => _ProfileConfigState();
}

class _ProfileConfigState extends State<ProfileConfig> {
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ApplicationState applicationState = context.read<ApplicationState>();
    User? user = applicationState.user;
    String? displayName = user?.displayName;
    UserData? userData = applicationState.userData;
    if (user == null) {
      return const MustBeLoggedIn();
    }
    if (userData == null) {
      return Scaffold(
        body: Center(
            child: Text(
          appLocalizations.generalError,
          style: const TextStyle(fontSize: 30, color: Colors.red),
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
              return AlertDialog(
                title: Text(appLocalizations.savingChanges),
                content: const Row(
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
                      Text(appLocalizations.successful)
                    ],
                  ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(appLocalizations.networkError),
                ),
              );
            }
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(appLocalizations.configureProfile)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ProfilePicPicker()],
              ),
              Field(
                icon: const Icon(Icons.person),
                title: appLocalizations.displayName,
                initialText: displayName,
                onChanged: (value) {
                  displayName = value;
                  newUserData.displayName = value;
                },
                maxLength: 40,
              ),
              Field(
                title: appLocalizations.userInfo,
                icon: const Icon(Icons.info),
                initialText: newUserData.info,
                onChanged: (value) {
                  newUserData.info = value;
                },
                maxLength: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.5, bottom: 12.5),
                child: Column(
                  children: [
                    Text(
                      appLocalizations.trainingInformation,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      appLocalizations.tIDetails,
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
                title: appLocalizations.history,
                initialText: newUserData.injuries,
                icon: const Icon(Icons.personal_injury),
                onChanged: (value) {
                  newUserData.injuries = value;
                },
                maxLines: 6,
                maxLength: 4000,
                hintText: appLocalizations.historyDetails,
              )
            ],
          ),
        ),
      ),
    );
  }
}
