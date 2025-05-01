// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_relay.c.dart';
import 'package:ion/app/features/ion_connect/model/related_token.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription_platform.c.dart';
import 'package:ion/app/features/push_notifications/providers/configure_firebase_messaging_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/relay_firebase_app_config_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/selected_push_categories_provider.c.dart';
import 'package:ion/app/services/device_id/device_id.c.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_ion_subscription_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SelectedPushCategoriesIonSubscription extends _$SelectedPushCategoriesIonSubscription {
  @override
  Future<PushSubscriptionData?> build() async {
    final relaysFirebaseConfig = await ref.watch(relayFirebaseAppConfigProvider.future);
    final fcmConfigured = await ref.watch(configureFirebaseMessagingProvider.future);

    if (relaysFirebaseConfig == null || !fcmConfigured) {
      return null;
    }

    final encryptedFcmToken =
        await _getEncryptedFcmToken(relayPubkey: relaysFirebaseConfig.relayPubkey);
    if (encryptedFcmToken == null) {
      return null;
    }

    return PushSubscriptionData(
      deviceId: await ref.watch(deviceIdServiceProvider).get(),
      platform: PushSubscriptionPlatform.forPlatform(),
      relay: RelatedRelay(url: relaysFirebaseConfig.relayUrl),
      fcmToken: RelatedToken(value: encryptedFcmToken),
      filters: await _getFilters(),
    );
  }

  Future<String?> _getEncryptedFcmToken({required String relayPubkey}) async {
    final fcmToken = await ref.watch(firebaseMessagingServiceProvider).getToken();
    if (fcmToken == null) {
      return null;
    }

    return fcmToken;
    // TODO: do not encrypt it for now until BE is ready
    // final encryptedMessageService = await ref.watch(encryptedMessageServiceProvider.future);
    // return encryptedMessageService.encryptMessage(fcmToken, publicKey: relayPubkey);
  }

  Future<List<RequestFilter>> _getFilters() async {
    final selectedPushCategories = ref.watch(selectedPushCategoriesProvider);
    if (selectedPushCategories.isEmpty) {
      return [];
    }
    //TODO: add filters
    return [];
  }
}
