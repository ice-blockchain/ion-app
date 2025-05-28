// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/pubkey_tag.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_block_event_service.c.g.dart';

@riverpod
Future<SendBlockEventService> sendBlockEventService(Ref ref) async {
  final sealService = await ref.watch(ionConnectSealServiceProvider.future);
  final wrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

  if (currentUserMasterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return SendBlockEventService(
    eventSigner: eventSigner,
    sealService: sealService,
    wrapService: wrapService,
    env: ref.watch(envProvider.notifier),
    currentUserMasterPubkey: currentUserMasterPubkey,
    ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
    devicePubkeysProvider: ref.watch(conversationPubkeysProvider.notifier),
  );
}

class SendBlockEventService {
  SendBlockEventService({
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.ionConnectNotifier,
    required this.currentUserMasterPubkey,
    required this.devicePubkeysProvider,
  });

  final Env env;
  final EventSigner eventSigner;
  final String currentUserMasterPubkey;
  final IonConnectSealService sealService;
  final IonConnectGiftWrapService wrapService;
  final IonConnectNotifier ionConnectNotifier;
  final ConversationPubkeys devicePubkeysProvider;

  Future<void> sendBlockEvent(String blockedUserMasterPubkey) async {
    try {
      final sharedId = generateUuid();
      final createdAt = DateTime.now();

      final participantsMasterPubkeys = [currentUserMasterPubkey, blockedUserMasterPubkey]
        ..sort((a, b) {
          if (a == currentUserMasterPubkey) return 1;
          if (b == currentUserMasterPubkey) return -1;
          return a.compareTo(b);
        });

      final participantsPubkeysMap =
          await devicePubkeysProvider.fetchUsersKeys(participantsMasterPubkeys);

      await Future.wait(
        participantsMasterPubkeys.map((masterPubkey) async {
          final pubkeyDevices = participantsPubkeysMap[masterPubkey];

          if (pubkeyDevices == null) throw UserPubkeyNotFoundException(masterPubkey);

          for (final pubkey in pubkeyDevices) {
            try {
              final eventMessage = await EventMessage.fromData(
                content: '',
                signer: eventSigner,
                createdAt: createdAt.microsecondsSinceEpoch,
                kind: BlockedUserEntity.kind,
                tags: [
                  ['d', sharedId],
                  PubkeyTag(value: blockedUserMasterPubkey).toTag(),
                  MasterPubkeyTag(value: currentUserMasterPubkey).toTag(),
                ],
              );

              await sendWrappedEvent(
                pubkey: pubkey,
                eventSigner: eventSigner,
                sealService: sealService,
                masterPubkey: masterPubkey,
                eventMessage: eventMessage,
                giftWrapService: wrapService,
                ionConnectNotifier: ionConnectNotifier,
              );
            } catch (e) {
              throw SendEventException(e.toString());
            }
          }
        }),
      );
    } catch (e) {
      throw SendEventException(e.toString());
    }
  }

  Future<void> sendDeleteBlockEvent(String dtag, String blockedUserMasterPubkey) async {
    try {
      final participantsMasterPubkeys = [currentUserMasterPubkey, blockedUserMasterPubkey]
        ..sort((a, b) {
          if (a == currentUserMasterPubkey) return 1;
          if (b == currentUserMasterPubkey) return -1;
          return a.compareTo(b);
        });

      final participantsPubkeysMap =
          await devicePubkeysProvider.fetchUsersKeys(participantsMasterPubkeys);

      final eventToDelete = EventToDelete(
        eventReference: ReplaceableEventReference(
          dTag: dtag,
          kind: BlockedUserEntity.kind,
          pubkey: currentUserMasterPubkey,
        ),
      );

      final deleteRequest = DeletionRequest(events: [eventToDelete]);

      final eventMessage = await deleteRequest.toEventMessage(
        NoPrivateSigner(eventSigner.publicKey),
        masterPubkey: currentUserMasterPubkey,
      );

      await Future.wait(
        participantsMasterPubkeys.map((masterPubkey) async {
          final pubkeyDevices = participantsPubkeysMap[masterPubkey];

          if (pubkeyDevices == null) throw UserPubkeyNotFoundException(masterPubkey);

          for (final pubkey in pubkeyDevices) {
            try {
              await sendWrappedEvent(
                pubkey: pubkey,
                eventSigner: eventSigner,
                sealService: sealService,
                masterPubkey: masterPubkey,
                eventMessage: eventMessage,
                giftWrapService: wrapService,
                ionConnectNotifier: ionConnectNotifier,
              );
            } catch (e) {
              throw SendEventException(e.toString());
            }
          }
        }),
      );
    } catch (e) {
      throw SendEventException(e.toString());
    }
  }

  Future<void> sendWrappedEvent({
    required String pubkey,
    required EventSigner eventSigner,
    required String masterPubkey,
    required EventMessage eventMessage,
    required IonConnectSealService sealService,
    required IonConnectNotifier ionConnectNotifier,
    required IonConnectGiftWrapService giftWrapService,
  }) async {
    final seal = await sealService.createSeal(eventMessage, eventSigner, pubkey);

    final giftWrap = await giftWrapService.createWrap(
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
}
