// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/push_notifications/providers/push_subscription_provider.c.dart';
import 'package:ion/app/features/push_notifications/providers/selected_push_categories_ion_subscription_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_subscription_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class PushSubscriptionSync extends _$PushSubscriptionSync {
  @override
  Future<void> build() async {
    final selectedPushCategoriesIonSubscription =
        await ref.watch(selectedPushCategoriesIonSubscriptionProvider.future);
    final publishedIonSubscription = await ref.watch(currentUserPushSubscriptionProvider.future);
    //TODO:wait for delegation complete
    if (selectedPushCategoriesIonSubscription != null &&
        selectedPushCategoriesIonSubscription != publishedIonSubscription?.data) {
      await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(
            selectedPushCategoriesIonSubscription,
            actionSource: ActionSourceRelayUrl(selectedPushCategoriesIonSubscription.relay.url),
          );
    }
  }
}
