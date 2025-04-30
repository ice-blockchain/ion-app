// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/related_relay.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription_platform.c.dart';
import 'package:ion/app/features/push_notifications/providers/relay_firebase_app_config_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/selected_push_categories_provider.c.dart';
import 'package:ion/app/services/device_id/device_id.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_push_categories_ion_subscription_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SelectedPushCategoriesIonSubscription extends _$SelectedPushCategoriesIonSubscription {
  @override
  Future<PushSubscriptionEntity?> build() async {
    final selectedPushCategories = await ref.watch(selectedPushCategoriesProvider.future);
    final deviceIdService = ref.watch(deviceIdServiceProvider);
    final relaysFirebaseConfig = await ref.watch(relayFirebaseAppConfigProvider.future);

    if (relaysFirebaseConfig == null) {
      return null;
    }

    return const PushSubscriptionData(
      deviceId: await deviceIdService.get(),
      platform: PushSubscriptionPlatform.forPlatform(),
      relay: RelatedRelay(url: relaysFirebaseConfig.relayUrl),
      fcmToken: null,
      filters: [],
    );
  }
}
