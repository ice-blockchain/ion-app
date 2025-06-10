// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/relay_info.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_info_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/relay_firebase_config.c.dart';
import 'package:ion/app/features/user/providers/ranked_user_relays_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/providers/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_firebase_app_config_provider.c.g.dart';

@Riverpod(keepAlive: true)
class RelayFirebaseAppConfig extends _$RelayFirebaseAppConfig {
  @override
  Future<RelayFirebaseConfig?> build() async {
    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) {
      return null;
    }

    final userRelay = await ref.watch(rankedCurrentUserRelaysProvider.future);
    if (userRelay == null) {
      return null;
    }

    final savedConfig = ref.watch(savedRelayFirebaseAppConfigProvider);

    final relayUrls = [...userRelay.urls];

    if (savedConfig != null && relayUrls.contains(savedConfig.relayUrl)) {
      return savedConfig;
    }

    while (relayUrls.isNotEmpty) {
      final relayUrl = relayUrls.first;
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
    final relayPubkey = relayInfo.pubkey;
    final firebaseConfigs = relayInfo.getFirebaseConfigsForPlatform();
    if (firebaseConfigs == null || relayPubkey == null || relayPubkey.isEmpty) {
      return null;
    }

    return RelayFirebaseConfig(
      firebaseConfig: firebaseConfigs.random,
      relayUrl: relayUrl,
      relayPubkey: relayPubkey,
    );
  }
}

@Riverpod(keepAlive: true)
class SavedRelayFirebaseAppConfig extends _$SavedRelayFirebaseAppConfig {
  @override
  RelayFirebaseConfig? build() {
    listenSelf((_, next) => _saveConfig(next));
    return _loadConfig();
  }

  set config(RelayFirebaseConfig config) {
    state = config;
  }

  Future<void> _saveConfig(RelayFirebaseConfig? relayFirebaseConfig) async {
    if (relayFirebaseConfig == null) {
      await ref.read(localStorageProvider).remove(_configuredFirebaseAppKey);
    } else {
      await ref.read(localStorageProvider).setString(
            _configuredFirebaseAppKey,
            jsonEncode(relayFirebaseConfig.toJson()),
          );
    }
  }

  RelayFirebaseConfig? _loadConfig() {
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

  static const String _configuredFirebaseAppKey = 'configured_firebase_app_key';
}

@riverpod
class BuildInFirebaseAppConfig extends _$BuildInFirebaseAppConfig {
  @override
  FirebaseConfig? build() {
    try {
      final env = ref.read(envProvider.notifier);
      return FirebaseConfig.fromJson(
        jsonDecode(env.get<String>(EnvVariable.FIREBASE_CONFIG)) as Map<String, dynamic>,
      );
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to load build-in Firebase app',
      );
      return null;
    }
  }
}
