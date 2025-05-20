// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/data/models/app_config_with_version.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_translations_provider.c.freezed.dart';
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
    return translations[locale] =
        await _translationsRepository.getConfig<PushNotificationTranslations>(
      'ion-app_push-notifications_translations_$locale',
      cacheStrategy: AppConfigCacheStrategy.localStorage,
      refreshInterval: _env.get<int>(EnvVariable.VERSIONS_CONFIG_REFETCH_INTERVAL),
      parser: (data) =>
          PushNotificationTranslations.fromJson(jsonDecode(data) as Map<String, dynamic>),
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

@freezed
class PushNotificationTranslations
    with _$PushNotificationTranslations
    implements AppConfigWithVersion {
  const factory PushNotificationTranslations({
    @JsonKey(name: '_version') required int version,
    NotificationTranslation? reply,
    NotificationTranslation? mention,
    NotificationTranslation? repost,
    NotificationTranslation? like,
    NotificationTranslation? follower,
    NotificationTranslation? chatReaction,
    NotificationTranslation? chatMessage,
    NotificationTranslation? paymentRequest,
    NotificationTranslation? paymentReceived,
  }) = _PushNotificationTranslations;

  factory PushNotificationTranslations.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationTranslationsFromJson(json);
}

@freezed
class NotificationTranslation with _$NotificationTranslation {
  const factory NotificationTranslation({
    String? title,
    String? body,
  }) = _NotificationTranslation;

  factory NotificationTranslation.fromJson(Map<String, dynamic> json) =>
      _$NotificationTranslationFromJson(json);
}
