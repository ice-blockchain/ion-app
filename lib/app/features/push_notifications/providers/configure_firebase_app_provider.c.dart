// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/relay_info.c.dart';
import 'package:ion/app/features/push_notifications/providers/relay_firebase_app_config_provider.c.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:ion/app/services/firebase/firebase_service_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_app_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebaseApp extends _$ConfigureFirebaseApp {
  @override
  Future<bool> build() async {
    final firebaseAppService = ref.watch(firebaseAppServiceProvider);
    // final savedFirebaseAppConfig = ref.watch(savedFirebaseAppConfigProvider);

    const savedFirebaseAppConfig = RelayFirebaseConfig(
      firebaseConfig: FirebaseConfig(
        apiKey: 'AIzaSyBLM-Nmg-YblI5Vl0dzgcKlG8Lob2dlEuk',
        appId: '1:355345238028:ios:ee303913dfee1a19520629',
        messagingSenderId: '355345238028',
        projectId: 'staging3-76387',
      ),
      relayUrl: '',
      relayPubkey: '',
    );

    if (!firebaseAppService.hasApp()) {
      // Always first initialize the previously configured app.
      // Otherwise we won't be able to re-configure it (delete + init again)
      // in case the configured relay is not available anymore.
      await _initializeFirebaseApp(savedFirebaseAppConfig);
      return true;
    }

    // final relayFirebaseAppConfig = await ref.watch(relayFirebaseAppConfigProvider.future);

    // if (relayFirebaseAppConfig != null) {
    //   if (savedFirebaseAppConfig != null && relayFirebaseAppConfig == savedFirebaseAppConfig) {
    //     return true;
    //   }

    //   final initialized = await _initializeFirebaseApp(relayFirebaseAppConfig);
    //   if (initialized) {
    //     ref.watch(savedFirebaseAppConfigProvider.notifier).config = relayFirebaseAppConfig;
    //     return true;
    //   }
    // }

    return false;
  }

  Future<bool> _initializeFirebaseApp(RelayFirebaseConfig relayFirebaseAppConfig) async {
    try {
      final firebaseAppService = ref.watch(firebaseAppServiceProvider);
      final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);

      if (firebaseAppService.hasApp()) {
        // Without revoking the fcm token, the app will still receive notifications from the deleted app.
        await firebaseMessagingService.deleteToken();
        await firebaseAppService.deleteApp();
      }

      final fbConfig = relayFirebaseAppConfig.firebaseConfig;
      await firebaseAppService.initializeApp(
        FirebaseAppOptions(
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
        message: 'Failed to configure Firebase app $relayFirebaseAppConfig',
      );
      return false;
    }
  }
}
