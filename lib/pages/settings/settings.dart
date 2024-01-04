import 'package:flutter/material.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:provider/provider.dart';

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
            appBar: AppBar(title: const Text('Settings')),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          'Theme:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton(
                            value: theme,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text('Same as System'),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text('Light'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('Dark'),
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
                  Switch(
                    value: localSettingsState.metricUnit,
                    onChanged: (value) {
                      setState(() {
                        localSettingsState.metricUnit = value;
                      });
                    },
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
