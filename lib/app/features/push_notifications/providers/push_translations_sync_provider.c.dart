// SPDX-License-Identifier: ice License 1.0

import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_translations_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class PushTranslationsSync extends _$PushTranslationsSync {
  @override
  void build() {
    final repository = ref.watch(pushTranslationsRepositoryProvider);

    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      fireImmediately: true,
      (previous, next) {
        if (next == AppLifecycleState.resumed) {
          repository.syncTranslations();
        }
      },
    );
  }
}

@Riverpod(keepAlive: true)
PushTranslationsRepository pushTranslationsRepository(Ref ref) {
  return PushTranslationsRepository(
    dio: ref.watch(dioProvider),
    locale: ref.watch(appLocaleProvider),
    localStorage: ref.watch(localStorageProvider),
    cacheDuration: Duration(
      minutes:
          ref.watch(envProvider.notifier).get<int>(EnvVariable.PUSH_TRANSLATIONS_CACHE_MINUTES),
    ),
  );
}

class PushTranslationsRepository {
  PushTranslationsRepository({
    required Dio dio,
    required Locale locale,
    required LocalStorage localStorage,
    required Duration cacheDuration,
  })  : _dio = dio,
        _locale = locale,
        _localStorage = localStorage,
        _cacheMaxDuration = cacheDuration;

  final Dio _dio;
  final Locale _locale;
  final LocalStorage _localStorage;
  final Duration _cacheMaxDuration;

  Future<String> syncTranslations() async {
    final file = File(await _cachePath);

    if (file.existsSync() && _fetchedForLocale(_locale)) {
      final cacheDuration = file.lastModifiedSync().difference(DateTime.now());
      if (cacheDuration < _cacheMaxDuration) {
        return file.readAsString();
      }
    }

    final translations = await _fetchTranslations();
    await file.writeAsString(translations);
    await _saveFetchedTranslationsLocale(_locale);
    return translations;
  }

  bool _fetchedForLocale(Locale locale) {
    final cachedLocale = _localStorage.getString(_translationsLangKey);
    return cachedLocale == locale.toLanguageTag();
  }

  Future<void> _saveFetchedTranslationsLocale(Locale locale) {
    return _localStorage.setString(_translationsLangKey, _locale.toLanguageTag());
  }

  Future<String> _fetchTranslations() async {
    try {
      //TODO:use _locale to fetch the correct translation
      final uri = Uri.parse('https://api.github.com/users/mralexgray/repos');
      final response = await _dio.getUri<String>(uri);
      return response.data!;
    } catch (error) {
      throw FetchPushTranslationsException(error);
    }
  }

  Future<String> get _cachePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_translationsFileName';
  }

  static const String _translationsFileName = 'push_translations.json';
  static const String _translationsLangKey = 'push_translations_lang';
}
