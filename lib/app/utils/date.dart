// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:intl/intl.dart';

/// Converts a timestamp to a more readable date string, with special handling
/// for dates that represent "today" and "yesterday".
///
/// The function checks if the given timestamp falls into today, yesterday, or
/// any other day. If it's today or yesterday, it returns localized strings for
/// these values. For other dates, it formats the date as 'MMM d yyyy'.
///
/// Parameters:
///   - `timestamp`: The Unix timestamp (in milliseconds) that will be converted
///     into a date string.
///   - `context`: The BuildContext used for accessing localized strings for
///     today and yesterday through an extension on BuildContext.
///
/// Returns: A string representing the human-readable date. This will be either
/// "today", "yesterday", or a date formatted as 'MMM d yyyy'.
String toPastDateDisplayValue(int timestamp, BuildContext context) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (date.year == today.year && date.month == today.month && date.day == today.day) {
    return context.i18n.date_today;
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return context.i18n.date_yesterday;
  }

  return DateFormat('MMM d yyyy').format(date);
}

/// Converts a timestamp to a time string in the format 'HH:mm'.
///
/// This method takes a Unix timestamp (in milliseconds) and formats it into
/// a string showing only the hours and minutes of the time.
///
/// Parameters:
///   - `timestamp`: The Unix timestamp (in milliseconds) that will be converted
///     into a time string.
///
/// Returns: A string representing the time in 'HH:mm' format.
String toTimeDisplayValue(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat('HH:mm').format(date);
}
