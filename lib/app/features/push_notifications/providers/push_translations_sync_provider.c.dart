// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_translations_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class PushTranslationsSync extends _$PushTranslationsSync {
  @override
  void build() {
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      fireImmediately: true,
      (previous, next) async {
        if (next == AppLifecycleState.resumed) {
          await _syncTranslations();
        }
      },
    );
  }

  Future<void> _syncTranslations() async {
    // try {
    //   final repository = await ref.read(minAppVersionRepositoryProvider.future);
    //   final minVersion = await repository.getMinVersion();

    //   final appInfo = await ref.read(appInfoProvider.future);
    //   final appVersion = '${appInfo.version}.${appInfo.buildNumber}';

    //   return compareVersions(appVersion, minVersion) == -1;
    // } catch (error, stackTrace) {
    //   Logger.error(
    //     error,
    //     stackTrace: stackTrace,
    //     message: 'Failed to check if force update is required',
    //   );
    //   return false;
    // }
  }
}

@Riverpod(keepAlive: true)
PushTranslationsRepository pushTranslationsRepository(Ref ref) {
  return PushTranslationsRepository(
    dio: ref.watch(dioProvider),
    locale: ref.watch(appLocaleProvider),
  );
}

class PushTranslationsRepository {
  PushTranslationsRepository({required Dio dio, required Locale locale})
      : _dio = dio,
        _locale = locale;

  final Dio _dio;
  final Locale _locale;

  Future<String> getTranslations(String relayUrl) async {
    try {
      final relayUri = Uri.parse(relayUrl);
      final infoUri = Uri(
        scheme: 'https',
        host: relayUri.host,
        port: relayUri.hasPort ? relayUri.port : null,
      );
      final response = await _dio.getUri<dynamic>(
        infoUri,
        options: Options(
          headers: {
            'Accept': 'application/nostr+json',
          },
        ),
      );
      return response.data.toString();
    } catch (error) {
      throw GetPushTranslationsException(error);
    }
  }
}
