/// Formats a logged-meal timestamp as a short, locale-agnostic label,
/// e.g. "8:30 AM", "Yesterday • 1:15 PM", "3/12 • 8:30 AM".
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
