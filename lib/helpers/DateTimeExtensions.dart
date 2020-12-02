import 'package:intl/intl.dart';

extension DateTimeToStringExtensions on DateTime {
  static final DateFormat date = new DateFormat('yMd');
  static final DateFormat time = new DateFormat('Hm');

  String formatDate() {
    return this != null 
      ? date.format(this)
      : '';
  }

  String formatTime() {
    return this != null 
      ? time.format(this)
      : '';
  }

  String formatDateTime() {
    return this != null 
      ? date.format(this) + " " + time.format(this)
      : '';
  }
}
extension StringToDateTimeExtensions on String {

  DateTime parseIso6801String() {
    return this != null
      ? DateTime.parse(this)
      : null;
  }

}