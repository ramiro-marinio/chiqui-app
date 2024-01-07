import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showinfodialog.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/widgets/infobutton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalSettings extends StatefulWidget {
  const LocalSettings({super.key});

  @override
  State<LocalSettings> createState() => _SettingsState();
}

class _SettingsState extends State<LocalSettings> {
  int theme = 0;
  @override
  Widget build(BuildContext context) {
    LocalSettingsState localSettingsState =
        Provider.of<LocalSettingsState>(context);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (!localSettingsState.loading) {
      theme = localSettingsState.theme;
    }
    return !localSettingsState.loading
        ? Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(
              title: Text(appLocalizations.settings),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          appLocalizations.theme,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: theme,
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(appLocalizations.sameAsOS),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(appLocalizations.light),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(appLocalizations.dark),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                localSettingsState.theme = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Text(
                          appLocalizations.units,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                appLocalizations.imperial,
                                style: TextStyle(
                                  color: adaptiveColor(
                                    const Color.fromARGB(255, 57, 131, 59),
                                    Colors.green,
                                    context,
                                  ),
                                ),
                              ),
                              Switch(
                                value: localSettingsState.metricUnit,
                                onChanged: (value) {
                                  showWarningDialog(
                                    title: appLocalizations.changeUnits,
                                    context: context,
                                    yes: () {
                                      setState(() {
                                        localSettingsState.metricUnit = value;
                                      });
                                    },
                                  );
                                },
                                activeColor: Colors.green,
                                trackOutlineColor:
                                    MaterialStateColor.resolveWith(
                                  (states) => Colors.transparent,
                                ),
                                inactiveThumbColor: Colors.blueGrey,
                                inactiveTrackColor:
                                    const Color.fromARGB(255, 61, 90, 103),
                              ),
                              Text(
                                appLocalizations.metric,
                                style: TextStyle(
                                  color: adaptiveColor(
                                      const Color.fromARGB(255, 57, 131, 59),
                                      Colors.green,
                                      context),
                                ),
                              ),
                              InfoButton(
                                icon: const Icon(Icons.info),
                                title: appLocalizations.metricOrImperial,
                                description: appLocalizations.moiDetails,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: appLocalizations.notifications,
                              style: TextStyle(
                                color: adaptiveColor(
                                  Colors.black,
                                  Colors.white,
                                  context,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: localSettingsState.notificationsAllowed
                                  ? appLocalizations.enabled
                                  : appLocalizations.disabled,
                              style: TextStyle(
                                color: localSettingsState.notificationsAllowed
                                    ? adaptiveColor(
                                        const Color.fromARGB(255, 60, 142, 63),
                                        Colors.green,
                                        context)
                                    : Colors.red,
                              ),
                            ),
                          ],
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: !localSettingsState.notificationsAllowed
                            ? () {
                                openAppSettings().then(
                                  (value) {
                                    if (!value) {
                                      showInfoDialog(
                                          title: appLocalizations.generalError,
                                          description: appLocalizations
                                              .errorEnablingNotifications,
                                          context: context);
                                    }
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          appLocalizations.enableNotifications,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          appLocalizations.language,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton(
                            onChanged: (value) {
                              localSettingsState.language = Locale(value!);
                            },
                            value: localSettingsState.language.languageCode,
                            items: [
                              DropdownMenuItem(
                                value: 'os',
                                child: Text(appLocalizations.sameAsOS),
                              ),
                              const DropdownMenuItem(
                                value: 'en',
                                child: Text('English'),
                              ),
                              const DropdownMenuItem(
                                value: 'es',
                                child: Text('Español'),
                              ),
                              const DropdownMenuItem(
                                value: 'pt',
                                child: Text('Português'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator.adaptive(),
          );
  }
}
