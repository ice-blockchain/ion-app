// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ui';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/data/models/app_config_with_version.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_notification_translations.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_translations_provider.c.g.dart';

class Translator<T extends AppConfigWithVersion> {
  Translator({
    required ConfigRepository translationsRepository,
    required Locale locale,
    required Env env,
  })  : _translationsRepository = translationsRepository,
        _locale = locale,
        _env = env;

  final ConfigRepository _translationsRepository;

  final Locale _locale;

  final Map<Locale, PushNotificationTranslations> translations = {};

  final Env _env;

  Future<String?> translate(
    String? Function(PushNotificationTranslations) selector,
  ) async {
    return _translate(selector, locale: _locale);
  }

  Future<String?> _translate(
    String? Function(PushNotificationTranslations) selector, {
    required Locale locale,
  }) async {
    try {
      final translations = await _getTranslations(locale);
      final translation = selector(translations);
      if (translation == null) {
        throw TranslationNotFoundException(locale);
      }
      return translation;
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to translate for locale $locale',
      );
      if (locale != fallbackLocale) {
        return _translate(selector, locale: fallbackLocale);
      }
      return null;
    }
  }

  Future<PushNotificationTranslations> _getTranslations(Locale locale) async {
    if (translations.containsKey(locale)) {
      return translations[locale]!;
    }
    final cacheDuration = _env.get<Duration>(EnvVariable.GENERIC_CONFIG_CACHE_DURATION);
    return translations[locale] =
        await _translationsRepository.getConfig<PushNotificationTranslations>(
      'ion-app_push-notifications_translations_${locale.languageCode}',
      cacheStrategy: AppConfigCacheStrategy.file,
      refreshInterval: cacheDuration.inMilliseconds,
      parser: (data) =>
          PushNotificationTranslations.fromJson(jsonDecode(data) as Map<String, dynamic>),
      checkVersion: true,
    );
  }

  static const Locale fallbackLocale = Locale('en', 'US');
}

@Riverpod(keepAlive: true)
Future<Translator<PushNotificationTranslations>> pushTranslator(Ref ref) async {
  final appLocale = ref.watch(appLocaleProvider);
  final translationsRepository = await ref.watch(configRepositoryProvider.future);
  return Translator(
    translationsRepository: translationsRepository,
    locale: appLocale,
    env: ref.read(envProvider.notifier),
  );
}
