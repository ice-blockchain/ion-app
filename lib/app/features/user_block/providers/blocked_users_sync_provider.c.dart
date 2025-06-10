// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/event_syncer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/user_block/model/database/block_user_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class BlockedUsersSync extends _$BlockedUsersSync {
  @override
  Stream<void> build() async* {
    // Wait for authentication and delegation
    final authState = await ref.watch(authProvider.future);
    if (!authState.isAuthenticated) return;

    final delegationComplete = await ref.watch(delegationCompleteProvider.future);
    if (!delegationComplete) return;

    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (masterPubkey == null) throw UserMasterPubkeyNotFoundException();

    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (eventSigner == null) throw EventSignerNotFoundException();

    final blockEventDao = ref.watch(blockEventDaoProvider);
    final unblockEventDao = ref.watch(unblockEventDaoProvider);

    final latestBlockEventDate = await ref.watch(blockEventDaoProvider).getLatestBlockEventDate();

    final requestFilter = RequestFilter(
      kinds: const [IonConnectGiftWrapEntity.kind],
      tags: {
        '#k': [
          BlockedUserEntity.kind.toString(),
          DeletionRequestEntity.kind.toString(),
        ],
        '#p': [
          [masterPubkey, '', eventSigner.publicKey],
        ],
      },
    );

    final env = ref.watch(envProvider.notifier);
    final overlap = Duration(days: env.get<int>(EnvVariable.BLOCKED_USERS_SYNC_OVERLAP_DAYS));

    final latestSyncedEventTimestamp =
        await ref.watch(eventSyncerProvider('blocked-users').notifier).syncEvents(
              overlap: overlap,
              requestFilters: [requestFilter],
              sinceDateMicroseconds: latestBlockEventDate?.microsecondsSinceEpoch,
              saveCallback: (wrap) => _handleBlockEvent(
                eventMessage: wrap,
                eventSigner: eventSigner,
                masterPubkey: masterPubkey,
                blockEventDao: blockEventDao,
                unblockEventDao: unblockEventDao,
              ),
            );

    final requestMessage = RequestMessage();

    final sinceWithOverlap = (latestSyncedEventTimestamp ?? DateTime.now().microsecondsSinceEpoch) -
        overlap.inMicroseconds;
    requestMessage.addFilter(
      requestFilter.copyWith(
        since: () => sinceWithOverlap,
      ),
    );

    final events = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));

    final subscription = events.listen(
      (wrap) => _handleBlockEvent(
        eventMessage: wrap,
        eventSigner: eventSigner,
        masterPubkey: masterPubkey,
        blockEventDao: blockEventDao,
        unblockEventDao: unblockEventDao,
      ),
    );

    ref.onDispose(subscription.cancel);

    yield null;
  }

  Future<void> _handleBlockEvent({
    required String masterPubkey,
    required EventSigner eventSigner,
    required EventMessage eventMessage,
    required BlockEventDao blockEventDao,
    required UnblockEventDao unblockEventDao,
  }) async {
    final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);
    final rumor = await giftUnwrapService.unwrap(eventMessage);

    if (rumor.kind == BlockedUserEntity.kind) {
      await blockEventDao.add(rumor);
    } else if (rumor.kind == DeletionRequestEntity.kind) {
      final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

      final eventToDeleteReferences =
          eventsToDelete.map((event) => (event as EventToDelete).eventReference).toList();
      if (eventToDeleteReferences.length == 1) {
        await unblockEventDao.add(eventToDeleteReferences.single);
      }
    }
  }
}
