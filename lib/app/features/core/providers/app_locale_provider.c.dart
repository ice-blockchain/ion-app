// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale_provider.c.g.dart';

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
    return PlatformDispatcher.instance.locale;
  }
}

@riverpod
Language localePreferredLanguage(Ref ref) {
  final appLocale = ref.watch(appLocaleProvider);
  return Language.values.firstWhereOrNull(
        (lang) => appLocale.languageCode.toLowerCase() == lang.isoCode.toLowerCase(),
      ) ??
      Language.english;
}
