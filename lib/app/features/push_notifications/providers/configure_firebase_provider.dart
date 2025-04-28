import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/relay_info_provider.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/services/firebase/firebase_service_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final configureFirebaseProvider = Provider<Future<void>>((ref) async {
  final authState = await ref.watch(authProvider.future);
  final firebaseService = ref.watch(firebaseServiceProvider);

  onLogout(ref, () async {
    //TODO: test recovery keys gd sync feature - it depends on the auth fb service
    await firebaseService.deleteApp();
  });

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
    try {
      final relayInfo = await ref.watch(relayInfoProvider(relayUrl).future);
      final fbConfigs = relayInfo.getFcmConfigsForPlatform();
      if (fbConfigs != null) {
        final fbConfig = fbConfigs.random;
        await firebaseService.configureApp(
          FirebaseAppConfig(
            apiKey: fbConfig.apiKey,
            appId: fbConfig.appId,
            messagingSenderId: fbConfig.messagingSenderId,
            projectId: fbConfig.projectId,
          ),
        );
        return;
      }
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to configure Firebase app from $relayUrl',
      );
    }
  }

  throw ConfigureFirebaseAppException();
});
