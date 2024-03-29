import 'package:flutter/cupertino.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:intl/intl.dart';

String toPastDateDisplayValue(int timestamp, BuildContext context) {
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateTime now = DateTime.now();
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime yesterday = today.subtract(const Duration(days: 1));

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return context.i18n.date_today;
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return context.i18n.date_yesterday;
  }

  return DateFormat('MMM d yyyy').format(date);
}

String toTimeDisplayValue(int timestamp) {
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('HH:mm').format(date);
}
