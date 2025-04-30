// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.c.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_messaging_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebaseMessaging extends _$ConfigureFirebaseMessaging {
  @override
  Future<void> build() async {
    // onLogout should be at the top of the build method
    onLogout(ref, _deleteFcmToken);

    final firebaseAppConfigured = await ref.watch(configureFirebaseAppProvider.future);

    if (firebaseAppConfigured) {
      await ref.watch(firebaseMessagingServiceProvider).registerForRemoteNotifications();
    }
  }

  void _deleteFcmToken() {
    ref.read(firebaseMessagingServiceProvider).deleteToken();
  }
}
