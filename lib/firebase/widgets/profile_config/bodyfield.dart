import 'package:flutter/material.dart';

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
    double stature = initialStature;
    double weight = initialWeight;
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.man),
                Text(
                  'Stature and Weight',
                  style: TextStyle(fontSize: 20),
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
                    '${stature.toInt()} cm',
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
                      '${weight.toInt()} kg',
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
