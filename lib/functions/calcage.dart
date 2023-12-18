int calculateAge(DateTime birthDay) {
  DateTime now = DateTime.now();
  int gap = now.year - birthDay.year - 1;
  if ((now.month == birthDay.month && now.day >= birthDay.day) ||
      now.month > birthDay.month) {
    gap += 1;
  }
  return gap;
}
