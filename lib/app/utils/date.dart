// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/extensions/build_context.dart';

/// Converts a timestamp (in milliseconds) into a human-readable string such as
/// "today", "yesterday", or a formatted date (MMM d yyyy).
///
/// If the [timestamp] falls on today's date, returns a localized "today".
/// If it falls on yesterday's date, returns a localized "yesterday".
/// Otherwise, it formats the date as 'MMM d yyyy' (or localized equivalent).
String toPastDateDisplayValue(int timestamp, BuildContext context, {Locale? locale}) {
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

  // For other dates, use localized yMMMd, e.g. "Jan 5, 2024"
  return DateFormat.yMMMd(locale?.languageCode).format(date);
}

/// Converts a timestamp (in milliseconds) into a time string in the 'HH:mm' format.
/// Honors the [locale] if provided.
///
/// Returns a string representing the time in 'HH:mm', e.g., "14:30".
String toTimeDisplayValue(int timestamp, {Locale? locale}) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return DateFormat.Hm(locale?.languageCode).format(date);
}

/// Formats a [Duration] into a string of the format 'mm:ss'.
///
/// For example, a duration of 125 seconds would be formatted as "02:05".
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return '$minutes:$seconds';
}

/// Formats a [DateTime] for message timestamps based on how far in the past
/// the given time is.
///
/// - If [dateTime] is today, returns "HH:mm".
/// - If it is within the past week, returns the day of the week (e.g., "Mon").
/// - If it is within the current year but older than a week, returns "dd/MM".
/// - Otherwise, returns "dd/MM/yyyy".
String formatMessageTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate == today) {
    return DateFormat.Hm().format(dateTime);
  }

  if (messageDate.isAfter(today.subtract(const Duration(days: 7)))) {
    return DateFormat.E().format(dateTime);
  }

  if (messageDate.year == today.year) {
    return DateFormat('dd/MM').format(dateTime);
  }

  return DateFormat('dd/MM/yyyy').format(dateTime);
}

/// Formats a [DateTime] into the "MMMM d, yyyy" format (e.g., "January 5, 2024").
String formatDateToMonthDayYear(DateTime date, {Locale? locale}) {
  return DateFormat('MMMM d, yyyy', locale?.languageCode).format(date);
}

/// Returns a random DateTime object before the current time.
///
/// [maxDuration]: The maximum duration before the current time.
/// Example:
/// ```dart
/// DateTime randomDate = randomDateBefore(const Duration(days: 2));
/// ```
///
DateTime randomDateBefore(Duration maxDuration) {
  final now = DateTime.now();
  final differenceInMilliseconds = now.difference(now.subtract(maxDuration)).inMilliseconds;
  final randomMilliseconds = Random().nextInt(differenceInMilliseconds);
  return now.subtract(Duration(milliseconds: randomMilliseconds));
}

/// Formats a [DateTime] to a short or relative style used on the feed.
///
/// - **< 60 minutes:** displays `[x]m`
/// - **< 24 hours:** displays `[x]h`
/// - **< 7 days:** displays `[x]d`
/// - **< 365 days:** displays short month and day, e.g. "Jan 10"
/// - **>= 365 days:** displays month, day, and year, e.g. "Jan 10, 2024"
///
/// [locale] is used for formatting the month/day/year fallback.
String formatFeedTimestamp(DateTime dateTime, {Locale? locale}) {
  final localDateTime = dateTime.toLocal();
  final now = DateTime.now();
  final difference = now.difference(localDateTime);
  final diffInMinutes = difference.inMinutes;
  final diffInHours = difference.inHours;
  final diffInDays = difference.inDays;

  if (diffInMinutes < 60) {
    return '${diffInMinutes}m';
  }

  if (diffInHours < 24) {
    return '${diffInHours}h';
  }

  if (diffInDays < 7) {
    return '${diffInDays}d';
  }

  if (diffInDays < 365) {
    return DateFormat.MMMd(locale?.languageCode).format(localDateTime);
  }

  // 12 months or more
  return DateFormat.yMMMd(locale?.languageCode).format(localDateTime);
}

/// Formats a [DateTime] to a detailed style used on post detail screens, such
/// as "Jan 1, 2024, 08:45 PM".
///
/// [locale] is used for formatting date/time localization.
String formatDetailedPostTime(DateTime dateTime, {Locale? locale}) {
  final localDateTime = dateTime.toLocal();
  final dateFormat = DateFormat('MMM d, yyyy, hh:mm a', locale?.languageCode);
  return dateFormat.format(localDateTime);
}
