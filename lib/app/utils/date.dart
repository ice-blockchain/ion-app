// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:ion/app/extensions/build_context.dart';

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

/// Formats a duration into a string in the format 'mm:ss'.
///
/// This method takes a Duration object and formats it into a string showing
/// only the minutes and seconds of the duration.
///
/// Parameters:
///  - `duration`: The Duration object that will be converted into a time string.
///
/// Returns: A string representing the duration in 'mm:ss' format.
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return '$minutes:$seconds';
}

/// Formats a timestamp into a human-readable string.
///
/// This method takes a [DateTime] object and formats it into a string that
/// represents the date in a human-readable format. The format of the string
/// depends on how far in the past the date is:
///
/// - If the timestamp is from today, it returns the time in "HH:mm" format.
/// - If the timestamp is from the current week, it returns the day of the week (e.g., "Mon").
/// - If the timestamp is from the current year but not the current week, it returns the date in "dd/MM" format.
/// - If the timestamp is from a previous year, it returns the date in "dd/MM/yyyy" format.
///
/// Example:
/// ```dart
/// formatMessageTimestamp(DateTime.now()); // Returns "14:30" if today
/// ```
///
/// [dateTime]: The DateTime object to be formatted.
/// Returns a formatted string based on the logic described above.
String formatMessageTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  // Check if it's today
  if (messageDate == today) {
    return DateFormat.Hm().format(dateTime); // Example: 14:30
  }

  // Check if it's within the past week
  if (messageDate.isAfter(today.subtract(const Duration(days: 7)))) {
    return DateFormat.E().format(dateTime); // Example: Mon
  }

  // Check if it's within the current year
  if (messageDate.year == today.year) {
    return DateFormat('dd/MM').format(dateTime); // Example: 17/10
  }

  // Otherwise, show full date with year
  return DateFormat('dd/MM/yyyy').format(dateTime); // Example: 17/10/2023
}
