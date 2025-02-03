// SPDX-License-Identifier: ice License 1.0

import 'package:timeago/timeago.dart';

class ShortTimeagoMessagesAdapter implements LookupMessages {
  ShortTimeagoMessagesAdapter(this.base);

  final LookupMessages base;

  String _removeTilde(String value) => value.replaceAll('~', '');

  @override
  String aboutAnHour(int minutes) => _removeTilde(base.aboutAnHour(minutes));

  @override
  String aDay(int hours) => _removeTilde(base.aDay(hours));

  @override
  String aboutAMonth(int days) => _removeTilde(base.aboutAMonth(days));

  @override
  String aboutAYear(int years) => _removeTilde(base.aboutAYear(years));

  @override
  String lessThanOneMinute(int seconds) => base.aboutAMinute(1);

  @override
  String prefixAgo() => base.prefixAgo();

  @override
  String prefixFromNow() => base.prefixFromNow();

  @override
  String suffixAgo() => base.suffixAgo();

  @override
  String suffixFromNow() => base.suffixFromNow();

  @override
  String aboutAMinute(int minutes) => _removeTilde(base.aboutAMinute(minutes));

  @override
  String minutes(int minutes) => base.minutes(minutes);

  @override
  String hours(int hours) => base.hours(hours);

  @override
  String days(int days) => base.days(days);

  @override
  String months(int months) => base.months(months);

  @override
  String years(int years) => base.years(years);

  @override
  String wordSeparator() => base.wordSeparator();
}
