import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimeFormatter on Timestamp {
  /// If the date is `today`, return "`Today at HH:mm a`"
  ///
  /// If the date is `yesterday`, return "`Yesterday at HH:mm a`"
  ///
  /// Otherwise, return "`MMM dd yyyy at HH:mm a`"
  ///
  /// Returns:
  ///   A string.
  String toCustomTime() {
    final date = toDate();
    bool isToday = date.day == DateTime.now().day;
    bool isYesterday =
        date.day == DateTime.now().subtract(const Duration(days: 1)).day;
    if (isToday) {
      return DateFormat('HH:mm').format(date);
    } else if (isYesterday) {
      return 'Yesterday at ${DateFormat('HH:mm').format(date)}';
    }
    return DateFormat('MMM dd yyyy HH:mm').format(date);
  }
}
