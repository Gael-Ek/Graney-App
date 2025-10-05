import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String formatNasaDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMM yyyy', 'es').format(date);
  }

  static DateTime parseNasaDate(String dateStr) {
    return DateTime.parse(dateStr);
  }
}
