import 'package:flutter_test/flutter_test.dart';
import 'package:qwitter_flutter_app/utils/date_humanizer.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateHelper', () {
    test('formatDateString should return "now" if the difference is less than 1 minute', () {
      final now = DateTime.now();
      final dateString = now.subtract(Duration(seconds: 30)).toIso8601String();
      expect(DateHelper.formatDateString(dateString), 'now');
    });

    test('formatDateString should return minutes if the difference is less than 1 hour', () {
      final now = DateTime.now();
      final dateString = now.subtract(Duration(minutes: 45)).toIso8601String();
      expect(DateHelper.formatDateString(dateString), '45m');
    });

    test('formatDateString should return hours if the difference is more than 1 hour', () {
      final now = DateTime.now();
      final dateString = now.subtract(Duration(hours: 3)).toIso8601String();
      expect(DateHelper.formatDateString(dateString), '3h');
    });

    test('formatDateString should return 1d if the difference is 1 day', () {
      final now = DateTime.now();
      final dateString = now.subtract(Duration(days: 1)).toIso8601String();
      expect(DateHelper.formatDateString(dateString), '1d');
    });

    test('formatDateString should return formatted date if the difference is more than 1 day', () {
      final dateString = '2023-12-25T12:00:00.000Z'; // Replace with an appropriate date
      expect(DateHelper.formatDateString(dateString), DateFormat('ddMMM').format(DateTime.parse(dateString)));
    });

    test('extractTime should return formatted time', () {
      final fullDate = '2023-12-25T12:30:00.000Z'; // Replace with an appropriate date
      expect(DateHelper.extractTime(fullDate), '12:30');
    });

    test('extractFullDate should return formatted date', () {
      final fullDate = '2023-12-25T12:00:00.000Z'; // Replace with an appropriate date
      expect(DateHelper.extractFullDate(fullDate), '25 Dec 23');
    });
  });
}
