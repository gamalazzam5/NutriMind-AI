
String formatMealTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour >= 12 ? 'PM' : 'AM';
  final time = '$hour12:$minute $period';

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  if (isSameDay(dateTime, now)) return time;

  final yesterday = now.subtract(const Duration(days: 1));
  if (isSameDay(dateTime, yesterday)) return 'Yesterday • $time';

  return '${dateTime.month}/${dateTime.day} • $time';
}
