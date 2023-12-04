String formatDuration(Duration duration) {
  String minutes = (duration.inMinutes).toString();
  String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
