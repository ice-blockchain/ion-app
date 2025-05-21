// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
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
    final authState = await ref.watch(authProvider.future);

    if (!authState.isAuthenticated) {
      return;
    }

    //TODO:uncomment
    // final delegationComplete = await ref.watch(delegationCompleteProvider.future);

    // if (!delegationComplete) {
    //   return;
    // }

    final selectedCategoriesSubscription =
        await ref.watch(selectedPushCategoriesIonSubscriptionProvider.future);
    final publishedSubscription = await ref.watch(currentUserPushSubscriptionProvider.future);

    if (selectedCategoriesSubscription != null &&
        selectedCategoriesSubscription.filters.isEmpty &&
        publishedSubscription != null) {
      await _deleteSubscription(publishedSubscription);
      return;
    }

    if (selectedCategoriesSubscription != null &&
        selectedCategoriesSubscription.filters.isNotEmpty &&
        selectedCategoriesSubscription != publishedSubscription?.data) {
      await ref.watch(ionConnectNotifierProvider.notifier).sendEntityData(
            selectedCategoriesSubscription,
            actionSource: ActionSourceRelayUrl(selectedCategoriesSubscription.relay.url),
          );
    }
  }

  Future<void> _deleteSubscription(PushSubscriptionEntity entity) async {
    await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
          DeletionRequest(
            events: [
              EventToDelete(
                eventReference: ImmutableEventReference(
                  pubkey: entity.masterPubkey,
                  eventId: entity.id,
                  kind: PushSubscriptionEntity.kind,
                ),
              ),
            ],
          ),
          cache: false,
        );
    ref.read(ionConnectCacheProvider.notifier).remove(entity.cacheKey);
  }
}
