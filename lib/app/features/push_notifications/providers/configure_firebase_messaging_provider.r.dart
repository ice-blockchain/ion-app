// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_app_provider.r.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configure_firebase_messaging_provider.r.g.dart';

@Riverpod(keepAlive: true)
class ConfigureFirebaseMessaging extends _$ConfigureFirebaseMessaging {
  @override
  Future<bool> build() async {
    // onLogout should be at the top of the build method
    onLogout(ref, _deleteFcmToken);

    final firebaseAppConfigured = await ref.watch(configureFirebaseAppProvider.future);

    if (firebaseAppConfigured) {
      // When we remove the default app on iOS, the firebase apns token is also gets removed from
      // the native FIRMessaging lib. So if we try to init a firebase app after removing the default one,
      // it fails to generate a fcm token (it can't be generated without apns one).
      //
      // To make it work we need to call `registerForRemoteNotifications`,
      // because it leads to `didRegisterForRemoteNotificationsWithDeviceToken` delegate method call
      // And eventually to `[[FIRMessaging messaging] setAPNSToken:deviceToken]`
      await ref.watch(firebaseMessagingServiceProvider).registerForRemoteNotifications();
      return true;
    }

    return false;
  }

  void _deleteFcmToken() {
    ref.read(firebaseMessagingServiceProvider).deleteToken();
  }
}
