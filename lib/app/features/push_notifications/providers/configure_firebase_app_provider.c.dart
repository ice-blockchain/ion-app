// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/push_notifications/providers/relay_firebase_app_config_provider.c.dart';
import 'package:ion/app/services/firebase/firebase_service_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_app_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebaseApp extends _$ConfigureFirebaseApp {
  @override
  Future<bool> build() async {
    final relayFirebaseConfig = await ref.watch(relayFirebaseAppConfigProvider.future);
    if (relayFirebaseConfig != null) {
      return _initializeFirebaseApp(relayFirebaseConfig);
    }

    return false;
  }

  Future<bool> _initializeFirebaseApp(RelayFirebaseConfig relayFirebaseConfig) async {
    try {
      final firebaseAppService = ref.watch(firebaseAppServiceProvider);

      if (firebaseAppService.hasApp()) {
        await firebaseAppService.deleteApp();
      }

      final fbConfig = relayFirebaseConfig.firebaseConfig;
      await firebaseAppService.initializeApp(
        FirebaseAppOptions(
          apiKey: fbConfig.apiKey,
          appId: fbConfig.appId,
          messagingSenderId: fbConfig.messagingSenderId,
          projectId: fbConfig.projectId,
        ),
      );

      await ref.watch(relayFirebaseAppConfigProvider.notifier).saveConfig(relayFirebaseConfig);
      return true;
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to configure Firebase app $relayFirebaseConfig',
      );
      return false;
    }
  }
}
