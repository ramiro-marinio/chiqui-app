import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BirthDayField extends StatefulWidget {
  final Function(DateTime dateTime) onChangeDatetime;
  final DateTime dateTime;
  const BirthDayField(
      {super.key, required this.onChangeDatetime, required this.dateTime});

  @override
  State<BirthDayField> createState() => _BirthDayFieldState();
}

class _BirthDayFieldState extends State<BirthDayField> {
  DateTime? displayDateTime;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    displayDateTime ??= widget.dateTime;
    return InkWell(
      onTap: () async {
        DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime.now());
        if (dateTime != null) {
          widget.onChangeDatetime(dateTime);
          setState(() {
            displayDateTime = dateTime;
          });
        }
      },
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Icon(Icons.cake),
                    baseline: TextBaseline.ideographic),
                TextSpan(
                  text: appLocalizations.birthdayHeader,
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'SansSerif',
                      textBaseline: TextBaseline.alphabetic),
                )
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(DateFormat('yyyy-MM-dd').format(displayDateTime!)),
            ),
          )
        ],
      ),
    );
  }
}
