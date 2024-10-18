// SPDX-License-Identifier: ice License 1.0

// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    return _getSystemLocale();
  }

  set locale(Locale locale) {
    state = locale;
  }

  Locale _getSystemLocale() {
    final locale = Platform.localeName; // e.g., 'en_US'
    final localeParts = locale.split('_');

    if (localeParts.length > 1) {
      return Locale(localeParts[0], localeParts[1]);
    } else {
      return Locale(localeParts[0]);
    }
  }
}

@riverpod
Language localePreferredLanguage(LocalePreferredLanguageRef ref) {
  final appLocale = ref.watch(appLocaleProvider);
  return Language.values.firstWhereOrNull((lang) => appLocale.languageCode == lang.isoCode) ??
      Language.english;
}
