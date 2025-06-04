// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/pubkey_tag.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/optimistic_ui/core/optimistic_sync_strategy.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/optimistic_ui/block_sync_strategy.dart';
import 'package:ion/app/features/user_block/optimistic_ui/model/blocked_user.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_sync_strategy_provider.c.g.dart';

@riverpod
SyncStrategy<BlockedUser> blockSyncStrategy(Ref ref) {
  final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
  final sealService = ref.watch(ionConnectSealServiceProvider).value;
  final wrapService = ref.watch(ionConnectGiftWrapServiceProvider).value;
  final eventSigner = ref.watch(currentUserIonConnectEventSignerProvider).value;
  final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);
  final devicePubkeysProvider = ref.watch(conversationPubkeysProvider.notifier);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  Future<void> sendWrappedEvent({
    required String pubkey,
    required String masterPubkey,
    required EventMessage eventMessage,
  }) async {
    if (sealService == null || wrapService == null) return;

    final seal = await sealService.createSeal(eventMessage, eventSigner, pubkey);

    final giftWrap = await wrapService.createWrap(
      event: seal,
      receiverPubkey: pubkey,
      receiverMasterPubkey: masterPubkey,
      contentKinds: [BlockedUserEntity.kind.toString()],
    );

    await ionConnectNotifier.sendEvent(
      giftWrap,
      cache: false,
      actionSource: ActionSourceUser(masterPubkey, anonymous: true),
    );
  }

  return BlockSyncStrategy(
    sendBlockEvent: (blockedUserMasterPubkey) async {
      final sharedId = generateUuid();

      final participantsMasterPubkeys = [currentUserMasterPubkey, blockedUserMasterPubkey]
        ..sort((a, b) {
          if (a == currentUserMasterPubkey) return 1;
          if (b == currentUserMasterPubkey) return -1;
          return a.compareTo(b);
        });

      final participantsPubkeysMap =
          await devicePubkeysProvider.fetchUsersKeys(participantsMasterPubkeys);

      await Future.wait(
        participantsMasterPubkeys.map((receiverMasterPubkey) async {
          final pubkeyDevices = participantsPubkeysMap[receiverMasterPubkey];

          if (pubkeyDevices == null) throw UserPubkeyNotFoundException(receiverMasterPubkey);

          for (final receiverPubkey in pubkeyDevices) {
            final createdAt = DateTime.now();

            final eventMessage = await EventMessage.fromData(
              content: '',
              signer: eventSigner,
              kind: BlockedUserEntity.kind,
              createdAt: createdAt.microsecondsSinceEpoch,
              tags: [
                // This is immutable event but with exception for dtag
                ['d', sharedId],
                PubkeyTag(value: blockedUserMasterPubkey).toTag(),
                MasterPubkeyTag(value: currentUserMasterPubkey).toTag(),
              ],
            );

            await sendWrappedEvent(
              pubkey: receiverPubkey,
              eventMessage: eventMessage,
              masterPubkey: receiverMasterPubkey,
            );
          }
        }),
      );
    },
    deleteBlockEvent: (blockedUserMasterPubkey, dtag) async {
      final participantsMasterPubkeys = [currentUserMasterPubkey, blockedUserMasterPubkey]
        ..sort((a, b) {
          if (a == currentUserMasterPubkey) return 1;
          if (b == currentUserMasterPubkey) return -1;
          return a.compareTo(b);
        });

      final participantsPubkeysMap =
          await devicePubkeysProvider.fetchUsersKeys(participantsMasterPubkeys);

      // Actually we are deleting immutable event, but there is no way to
      // pass dtag tag information
      final eventReference = ReplaceableEventReference(
        dTag: dtag,
        kind: BlockedUserEntity.kind,
        pubkey: currentUserMasterPubkey,
      );

      final eventToDelete = EventToDelete(eventReference: eventReference);

      final deleteRequest = DeletionRequest(events: [eventToDelete]);

      final eventMessage = await deleteRequest.toEventMessage(
        NoPrivateSigner(eventSigner.publicKey),
        masterPubkey: currentUserMasterPubkey,
      );

      await Future.wait(
        participantsMasterPubkeys.map((receiverMasterPubkey) async {
          final pubkeyDevices = participantsPubkeysMap[receiverMasterPubkey];

          if (pubkeyDevices == null) throw UserPubkeyNotFoundException(receiverMasterPubkey);

          for (final receiverPubkey in pubkeyDevices) {
            await sendWrappedEvent(
              pubkey: receiverPubkey,
              eventMessage: eventMessage,
              masterPubkey: receiverMasterPubkey,
            );
          }
        }),
      );
    },
  );
}
