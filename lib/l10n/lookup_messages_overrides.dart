// SPDX-License-Identifier: ice License 1.0

import 'package:timeago/timeago.dart';

class LessThanOneMinuteAsAboutAMinute implements LookupMessages {
  LessThanOneMinuteAsAboutAMinute(this.base);
  final LookupMessages base;

  @override
  String lessThanOneMinute(int seconds) {
    return base.aboutAMinute(1);
  }

  @override
  String prefixAgo() => base.prefixAgo();
  @override
  String prefixFromNow() => base.prefixFromNow();
  @override
  String suffixAgo() => base.suffixAgo();
  @override
  String suffixFromNow() => base.suffixFromNow();

  @override
  String aboutAMinute(int minutes) => base.aboutAMinute(minutes);
  @override
  String minutes(int minutes) => base.minutes(minutes);
  @override
  String aboutAnHour(int minutes) => base.aboutAnHour(minutes);
  @override
  String hours(int hours) => base.hours(hours);
  @override
  String aDay(int hours) => base.aDay(hours);
  @override
  String days(int days) => base.days(days);
  @override
  String aboutAMonth(int days) => base.aboutAMonth(days);
  @override
  String months(int months) => base.months(months);
  @override
  String aboutAYear(int year) => base.aboutAYear(year);
  @override
  String years(int years) => base.years(years);

  @override
  String wordSeparator() => base.wordSeparator();
}
