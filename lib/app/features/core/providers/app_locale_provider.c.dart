// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/model/language.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale_provider.c.g.dart';

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  @override
  Locale build() {
    listenSelf((_, next) => _saveState(next));
    final appLocal = _loadSavedState();
    Intl.defaultLocale = appLocal.toLanguageTag();
    return appLocal;
  }

  set locale(Locale locale) {
    final newLocale = _validateLocale(locale);
    Intl.defaultLocale = newLocale.toLanguageTag();
    state = newLocale;
  }

  Locale _getSystemLocale() {
    return _validateLocale(PlatformDispatcher.instance.locale);
  }

  Locale _validateLocale(Locale locale) {
    final isSupported = I18n.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
    return isSupported ? locale : const Locale('en');
  }

  void _saveState(Locale? state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || state == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_localePersistenceKey, json.encode(state.languageCode));
  }

  Locale _loadSavedState() {
    final systemLocale = _getSystemLocale();
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null) {
      return systemLocale;
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedAppLocale = userPreferencesService.getValue<String>(_localePersistenceKey);
    return savedAppLocale != null ? Locale(json.decode(savedAppLocale) as String) : systemLocale;
  }

  static const _localePersistenceKey = 'app_locale';
}

@riverpod
Language localePreferredLanguage(Ref ref) {
  final appLocale = ref.watch(appLocaleProvider);
  return Language.fromIsoCode(appLocale.languageCode) ?? Language.english;
}
