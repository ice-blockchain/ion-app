// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_info_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/firebase/firebase_service_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebase extends _$ConfigureFirebase {
  @override
  Future<void> build() async {
    final firebaseService = ref.watch(firebaseServiceProvider);

    // onLogout should be at the top of the build method
    onLogout(ref, firebaseService.deleteApp);

    final authState = await ref.watch(authProvider.future);

    if (!authState.isAuthenticated || firebaseService.hasApp()) {
      return;
    }

    final userRelay = await ref.watch(currentUserRelayProvider.future);

    if (userRelay == null) {
      return;
    }

    final relayUrls = [...userRelay.urls];

    while (relayUrls.isNotEmpty) {
      final relayUrl = relayUrls.random;
      relayUrls.remove(relayUrl);
      final configured = await _configureFirebaseAppForRelay(relayUrl);
      if (configured) {
        return;
      }
    }

    throw ConfigureFirebaseAppException();
  }

  Future<bool> _configureFirebaseAppForRelay(String relayUrl) async {
    try {
      final firebaseService = ref.watch(firebaseServiceProvider);
      final relayInfo = await ref.watch(relayInfoProvider(relayUrl).future);
      final fbConfigs = relayInfo.getFcmConfigsForPlatform();
      if (fbConfigs == null) {
        return false;
      }

      final fbConfig = fbConfigs.random;
      await firebaseService.configureApp(
        FirebaseAppConfig(
          apiKey: fbConfig.apiKey,
          appId: fbConfig.appId,
          messagingSenderId: fbConfig.messagingSenderId,
          projectId: fbConfig.projectId,
        ),
      );
      return true;
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to configure Firebase app from $relayUrl',
      );
      return false;
    }
  }
}
