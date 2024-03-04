import 'package:flutter/material.dart';
import 'package:gymapp/functions/imperial_system/stature.dart';
import 'package:gymapp/local_settings/local_settings_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyField extends StatelessWidget {
  final double initialStature;
  final double initialWeight;
  final Function(double value) setStature;
  final Function(double value) setWeight;
  const BodyField({
    super.key,
    required this.initialStature,
    required this.initialWeight,
    required this.setStature,
    required this.setWeight,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    LocalSettingsState localSettingsState =
        Provider.of<LocalSettingsState>(context);
    double stature = initialStature;
    double weight = initialWeight;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.balance),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.man),
                ),
                Text(
                  appLocalizations.statureAndWeight,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: stature,
                    min: 100,
                    max: 230,
                    onChanged: (value) {
                      setState(() {
                        stature = value.round().toDouble();
                      });
                      setStature(value.round().toDouble());
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    localSettingsState.metricUnit
                        ? '${stature.toInt()} cm.'
                        : statureImperialSystem(stature),
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: weight,
                    min: 35,
                    max: 220,
                    onChanged: (value) {
                      setState(() {
                        weight = value.round().toDouble();
                      });
                      setWeight(value.round().toDouble());
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      localSettingsState.metricUnit
                          ? '${weight.toInt()} kg.'
                          : '${weightImperialSystem(weight)} lb.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
