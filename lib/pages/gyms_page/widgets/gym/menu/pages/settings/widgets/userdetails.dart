import 'package:flutter/material.dart';
import 'package:gymapp/firebase/auth/userdata.dart';
import 'package:gymapp/functions/calcage.dart';
import 'package:gymapp/functions/imperial_system/stature.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetails extends StatelessWidget {
  final UserData userData;
  const UserDetails({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    LocalSettingsState localSettingsState =
        Provider.of<LocalSettingsState>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.details),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userData.displayName,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${calculateAge(userData.birthDay)} years old',
                style: const TextStyle(fontSize: 35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: userData.sex
                        ? const Icon(
                            Icons.female,
                            size: 30,
                          )
                        : const Icon(
                            Icons.male,
                            size: 30,
                          ),
                  ),
                  Text(
                    userData.sex ? 'Female' : 'Male',
                    style: const TextStyle(fontSize: 25),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Personal Information: \n${userData.info}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ZoomAvatar(photoURL: userData.photoURL, radius: 120),
            ),
            Text(
              'Stature: ${localSettingsState.metricUnit ? userData.stature.toInt() : statureImperialSystem(userData.stature)} ${localSettingsState.metricUnit ? 'cm.' : ''}',
              style: const TextStyle(fontSize: 25),
            ),
            Text(
              'Weight: ${localSettingsState.metricUnit ? userData.weight.toInt() : weightImperialSystem(userData.weight)} ${localSettingsState.metricUnit ? 'kg.' : 'lb.'}',
              style: const TextStyle(fontSize: 25),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'History:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                userData.injuries.isEmpty ? 'No Injuries' : userData.injuries,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
