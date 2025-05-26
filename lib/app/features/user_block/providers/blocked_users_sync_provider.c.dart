// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/user_block/model/database/blocked_users_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blocked_users_sync_provider.c.g.dart';

@Riverpod(keepAlive: true)
class BlockedUsersSync extends _$BlockedUsersSync {
  @override
  Stream<void> build() async* {
    final authState = await ref.watch(authProvider.future);

    if (!authState.isAuthenticated) {
      return;
    }

    final delegationComplete = await ref.watch(delegationCompleteProvider.future);

    if (!delegationComplete) {
      return;
    }

    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (masterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final latestBlockEventDate = await ref.watch(blockEventDaoProvider).getLatestBlockEventDate();

    final sinceDate = latestBlockEventDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      limit: -1,
      kinds: const [IonConnectGiftWrapEntity.kind],
      tags: {
        '#k': [
          BlockedUserEntity.kind.toString(),
          DeletionRequestEntity.kind.toString(),
        ],
        '#p': [masterPubkey],
      },
      since: sinceDate,
    );

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
    final blockEventDao = ref.watch(blockEventDaoProvider);

    await ref.watch(entitiesSyncerNotifierProvider('blocked-users').notifier).syncEvents(
      requestFilters: [requestFilter],
      overlap: const Duration(days: 2),
      saveCallback: (wrap) => _handleBlockEvent(
        eventMessage: wrap,
        eventSigner: eventSigner,
        sealService: sealService,
        masterPubkey: masterPubkey,
        blockEventDao: blockEventDao,
        giftWrapService: giftWrapService,
      ),
      maxCreatedAtBuilder: () => ref.watch(blockEventDaoProvider).getLatestBlockEventDate(),
      minCreatedAtBuilder: (since) =>
          ref.watch(blockEventDaoProvider).getEarliestBlockEventDate(after: since),
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final events = ref.watch(ionConnectEventsSubscriptionProvider(requestMessage));

    final subscription = events.listen(
      (wrap) => _handleBlockEvent(
        eventMessage: wrap,
        eventSigner: eventSigner,
        sealService: sealService,
        masterPubkey: masterPubkey,
        blockEventDao: blockEventDao,
        giftWrapService: giftWrapService,
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
    required IonConnectSealService sealService,
    required IonConnectGiftWrapService giftWrapService,
  }) async {
    if (eventSigner.publicKey != _receiverDevicePubkey(eventMessage)) {
      return;
    }

    final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);

    final rumor = await giftUnwrapService.unwrap(eventMessage);

    if (rumor.kind == BlockedUserEntity.kind) {
      await blockEventDao.add(rumor);
    } else if (rumor.kind == DeletionRequestEntity.kind) {
      final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

      final eventToDeleteReferences = eventsToDelete
          .map((event) => (event as EventToDelete).eventReference as ReplaceableEventReference)
          .toList();

      await blockEventDao.markAsDeleted(eventToDeleteReferences);
    }
  }

  String _receiverDevicePubkey(EventMessage wrap) {
    final senderPubkey = wrap.tags.firstWhereOrNull((tags) => tags[0] == 'p')?.elementAtOrNull(3);

    if (senderPubkey == null) {
      throw ReceiverDevicePubkeyNotFoundException(wrap.id);
    }

    return senderPubkey;
  }
}
