// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
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

    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

    if (!delegationComplete) {
      return;
    }

    if (selectedPushCategoriesIonSubscription != null &&
        selectedPushCategoriesIonSubscription.filters.isEmpty &&
        publishedIonSubscription != null) {
      await _deleteSubscription(publishedIonSubscription);
      return;
    }

    if (selectedPushCategoriesIonSubscription != null &&
        selectedPushCategoriesIonSubscription.filters.isNotEmpty &&
        selectedPushCategoriesIonSubscription != publishedIonSubscription?.data) {
      await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(
            selectedPushCategoriesIonSubscription,
            actionSource: ActionSourceRelayUrl(selectedPushCategoriesIonSubscription.relay.url),
          );
    }
  }

  Future<void> _deleteSubscription(PushSubscriptionEntity entity) async {
    await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
          DeletionRequest(
            events: [EventToDelete(eventId: entity.id, kind: PushSubscriptionEntity.kind)],
          ),
          cache: false,
        );
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }
}
