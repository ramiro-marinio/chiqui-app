String statureImperialSystem(double cm) {
  int feet = cm ~/ 30.48;
  double inches = (cm - feet * 30.48) / 2.54;
  return '$feet\' ${inches.toStringAsFixed(1)}"';
}

int weightImperialSystem(double kg) => (kg * 2.205).round();
