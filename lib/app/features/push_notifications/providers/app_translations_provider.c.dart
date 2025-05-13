// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_translations_provider.c.g.dart';
part 'app_translations_provider.c.freezed.dart';

class Translator<T extends TranslationWithVersion> {
  Translator({
    required AppTranslationsRepository<T> translationsRepository,
    required Locale locale,
  })  : _translationsRepository = translationsRepository,
        _locale = locale;

  final AppTranslationsRepository<T> _translationsRepository;

  final Locale _locale;

  final Map<Locale, T> translations = {};

  Future<String?> translate(
    String? Function(T) selector,
  ) async {
    return _translate(selector, locale: _locale);
  }

  Future<String?> _translate(
    String? Function(T) selector, {
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

  Future<T> _getTranslations(Locale locale) async {
    if (translations.containsKey(locale)) {
      return translations[locale]!;
    }
    return translations[locale] = await _translationsRepository.getTranslations(locale: locale);
  }

  static const Locale fallbackLocale = Locale('en', 'US');
}

@Riverpod(keepAlive: true)
Future<Translator<PushNotificationTranslations>> pushTranslator(Ref ref) async {
  final appLocale = ref.watch(appLocaleProvider);
  final translationsRepository = await ref.watch(pushTranslationsRepositoryProvider.future);
  return Translator(translationsRepository: translationsRepository, locale: appLocale);
}

@Riverpod(keepAlive: true)
Future<AppTranslationsRepository<PushNotificationTranslations>> pushTranslationsRepository(
  Ref ref,
) async {
  return AppTranslationsRepository(
    dio: ref.watch(dioProvider),
    ionOrigin: ref.watch(envProvider.notifier).get<String>(EnvVariable.ION_ORIGIN),
    path: 'ion-app_push-notifications_translations',
    localStorage: await ref.watch(localStorageAsyncProvider.future),
    cacheDuration: Duration(
      minutes:
          ref.watch(envProvider.notifier).get<int>(EnvVariable.PUSH_TRANSLATIONS_CACHE_MINUTES),
    ),
  );
}

class AppTranslationsRepository<T extends TranslationWithVersion> {
  AppTranslationsRepository({
    required Dio dio,
    required String ionOrigin,
    required String path,
    required LocalStorage localStorage,
    required Duration cacheDuration,
  })  : _dio = dio,
        _ionOrigin = ionOrigin,
        _path = path,
        _localStorage = localStorage,
        _cacheMaxDuration = cacheDuration;

  final Dio _dio;
  final String _ionOrigin;
  final String _path;
  final LocalStorage _localStorage;
  final Duration _cacheMaxDuration;

  Future<T> getTranslations({required Locale locale}) async {
    final cacheFile = File(await _getCachePath(locale: locale));

    if (cacheFile.existsSync()) {
      final cacheDuration = DateTime.now().difference(cacheFile.lastModifiedSync());
      if (cacheDuration < _cacheMaxDuration) {
        return _parseTranslations(await cacheFile.readAsString());
      }
    }

    final translations = await _fetchTranslations(locale: locale);
    if (translations == null) {
      if (!cacheFile.existsSync()) {
        // This should not happen, but just in case, to avoid getting stuck in a loop
        await _localStorage.remove(_getCacheVersionKey(locale: locale));
        throw AppTranslationsCacheNotFoundException(locale);
      }
      await cacheFile.setLastModified(DateTime.now());
      return _parseTranslations(await cacheFile.readAsString());
    }

    final appTranslations = _parseTranslations(translations);
    await cacheFile.writeAsString(translations);
    await _localStorage.setInt(_getCacheVersionKey(locale: locale), appTranslations.version);
    return appTranslations;
  }

  T _parseTranslations(String translations) {
    try {
      if (T == PushNotificationTranslations) {
        return PushNotificationTranslations.fromJson(
          jsonDecode(translations) as Map<String, dynamic>,
        ) as T;
      } else {
        throw UnsupportedTranslationTypeException(T);
      }
    } catch (error) {
      throw ParseAppTranslationsException(error);
    }
  }

  Future<String?> _fetchTranslations({required Locale locale}) async {
    try {
      final cacheVersion = _localStorage.getInt(_getCacheVersionKey(locale: locale)) ?? 0;
      final uri = Uri.parse(_ionOrigin).replace(
        path: '/v1/config/${_path}_${locale.languageCode}',
        queryParameters: {
          'version': cacheVersion.toString(),
        },
      );
      final response = await _dio.getUri<String>(uri);
      if (response.statusCode == HttpStatus.noContent) {
        return null;
      }
      return response.data!;
    } catch (error) {
      throw FetchAppTranslationsException(error);
    }
  }

  Future<String> _getCachePath({required Locale locale}) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${_getCacheFileName(locale: locale)}';
  }

  String _getCacheFileName({required Locale locale}) =>
      'app_translations.${locale.languageCode}.json';

  String _getCacheVersionKey({required Locale locale}) => 'cache_version_${locale.languageCode}';
}

abstract class TranslationWithVersion {
  int get version;
}

@freezed
class PushNotificationTranslations
    with _$PushNotificationTranslations
    implements TranslationWithVersion {
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
