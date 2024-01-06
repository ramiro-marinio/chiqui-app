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
    if (!localSettingsState.loading) {
      theme = localSettingsState.theme;
    }
    return !localSettingsState.loading
        ? Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.settings),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.theme,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: theme,
                            items: [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                    AppLocalizations.of(context)!.sameAsOS),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child:
                                    Text(AppLocalizations.of(context)!.light),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(AppLocalizations.of(context)!.dark),
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
                          AppLocalizations.of(context)!.units,
                          style: const TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.imperial,
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
                                    title: AppLocalizations.of(context)!
                                        .changeUnits,
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
                                AppLocalizations.of(context)!.metric,
                                style: TextStyle(
                                  color: adaptiveColor(
                                      const Color.fromARGB(255, 57, 131, 59),
                                      Colors.green,
                                      context),
                                ),
                              ),
                              InfoButton(
                                icon: const Icon(Icons.info),
                                title: AppLocalizations.of(context)!
                                    .metricOrImperial,
                                description:
                                    AppLocalizations.of(context)!.moiDetails,
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
                              text: AppLocalizations.of(context)!.notifications,
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
                                  ? AppLocalizations.of(context)!.enabled
                                  : AppLocalizations.of(context)!.disabled,
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
                                          title: AppLocalizations.of(context)!
                                              .generalError,
                                          description:
                                              AppLocalizations.of(context)!
                                                  .errorEnablingNotifications,
                                          context: context);
                                    }
                                  },
                                );
                              }
                            : null,
                        child: Text(
                          AppLocalizations.of(context)!.enableNotifications,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
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
