// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/relay_info.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_info_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_firebase_app_config_provider.c.freezed.dart';
part 'relay_firebase_app_config_provider.c.g.dart';

@Riverpod(keepAlive: true)
class RelayFirebaseAppConfig extends _$RelayFirebaseAppConfig {
  static const String _configuredFirebaseAppKey = 'configured_firebase_app_key';

  @override
  Future<RelayFirebaseConfig?> build() async {
    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) {
      return null;
    }

    final userRelay = await ref.watch(currentUserRelayProvider.future);
    if (userRelay == null) {
      return null;
    }

    final relayUrls = [...userRelay.urls];

    final savedFirebaseConfig = await _loadConfig();

    if (savedFirebaseConfig != null && relayUrls.contains(savedFirebaseConfig.relayUrl)) {
      return savedFirebaseConfig;
    }

    while (relayUrls.isNotEmpty) {
      final relayUrl = relayUrls.random;
      relayUrls.remove(relayUrl);
      final relayFirebaseConfig = await _getRelayFirebaseConfig(relayUrl);
      if (relayFirebaseConfig != null) {
        return relayFirebaseConfig;
      }
    }

    return null;
  }

  Future<RelayFirebaseConfig?> _getRelayFirebaseConfig(String relayUrl) async {
    final relayInfo = await ref.watch(relayInfoProvider(relayUrl).future);
    final firebaseConfigs = relayInfo.getFirebaseConfigsForPlatform();
    if (firebaseConfigs == null) {
      return null;
    }
    return RelayFirebaseConfig(firebaseConfig: firebaseConfigs.random, relayUrl: relayUrl);
  }

  Future<void> saveConfig(RelayFirebaseConfig relayFirebaseConfig) async {
    await ref.read(localStorageProvider).setString(
          _configuredFirebaseAppKey,
          jsonEncode(relayFirebaseConfig.toJson()),
        );
  }

  Future<RelayFirebaseConfig?> _loadConfig() async {
    try {
      final relayFirebaseConfigJson =
          ref.read(localStorageProvider).getString(_configuredFirebaseAppKey);
      if (relayFirebaseConfigJson == null) {
        return null;
      }
      return RelayFirebaseConfig.fromJson(
        jsonDecode(relayFirebaseConfigJson) as Map<String, dynamic>,
      );
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to load configured Firebase app',
      );
      return null;
    }
  }
}

@freezed
class RelayFirebaseConfig with _$RelayFirebaseConfig {
  const factory RelayFirebaseConfig({
    required String relayUrl,
    required FirebaseConfig firebaseConfig,
  }) = _RelayFirebaseConfig;

  factory RelayFirebaseConfig.fromJson(Map<String, dynamic> json) =>
      _$RelayFirebaseConfigFromJson(json);
}
