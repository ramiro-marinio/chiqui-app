import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.cake),
              ),
              Text(
                "Birthday (Tap to modify)",
                style: TextStyle(fontSize: 20),
              ),
            ],
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
