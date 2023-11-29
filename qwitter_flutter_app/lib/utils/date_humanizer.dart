import 'package:intl/intl.dart';

class DateHelper {
  static String formatDateString(String dateString) {
    final parsedDate = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(parsedDate);

    if (difference.inDays == 0) {
      if (difference.inMinutes < 1) {
        return 'now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m';
      } else {
        return '${difference.inHours}h';
      }
    }

    if (difference.inDays == 1) {
      return '1d';
    }

    return DateFormat('ddMMM').format(parsedDate);
  }

  static String extractTime(String fullDate) {
    DateTime dateTime = DateTime.parse(fullDate);

    // Extracting time components
    String formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  static String extractFullDate(String fullDate) {
    DateTime dateTime = DateTime.parse(fullDate);

    return DateFormat('dd MMM yy').format(dateTime);
  }
}

