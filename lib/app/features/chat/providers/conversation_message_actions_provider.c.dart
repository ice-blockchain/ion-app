// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:nip44/nip44.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_message_actions_provider.c.g.dart';

@Riverpod(keepAlive: true)
Raw<Future<ConversationMessageActionsService>> conversationMessageActionsService(
  Ref ref,
) async {
  final databaseService = ref.watch(conversationsDBServiceProvider);
  final conversationMessageManagementService =
      await ref.watch(conversationMessageManagementServiceProvider);

  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return ConversationMessageActionsService(
    eventSigner: eventSigner,
    databaseService: databaseService,
    env: ref.watch(envProvider.notifier),
    userPubkey: await ref.watch(currentPubkeySelectorProvider.future),
    sealService: ref.watch(ionConnectSealServiceProvider),
    ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
    wrapService: ref.watch(ionConnectGiftWrapServiceProvider),
    conversationMessageManagementService: conversationMessageManagementService,
  );
}

class ConversationMessageActionsService {
  ConversationMessageActionsService({
    required this.env,
    required this.userPubkey,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.ionConnectNotifier,
    required this.databaseService,
    required this.conversationMessageManagementService,
  });

  final Env env;
  final String? userPubkey;
  final EventSigner? eventSigner;
  final IonConnectNotifier ionConnectNotifier;
  final IonConnectSealService sealService;
  final IonConnectGiftWrapService wrapService;
  final ConversationsDBService databaseService;
  final ConversationMessageManagementService conversationMessageManagementService;

  Future<void> deleteMessage(String id) async {
    await databaseService.markConversationMessageAsDeleted(id);
  }

  Future<void> bookmarkMessage(List<String> ids, String receiverPubkey) async {
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final createdAt = DateTime.now().toUtc();

    final encodedRumor = jsonEncode([
      ids.map((id) => ['e', id]).toList(),
    ]);

    final tags = [
      const ReplaceableEventIdentifier(value: 'chat_messages').toTag(),
      ['encrypted'],
    ];

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      eventSigner!.privateKey,
      receiverPubkey,
    );

    final id = EventMessage.calculateEventId(
      tags: tags,
      createdAt: createdAt,
      content: encryptedRumor,
      publicKey: receiverPubkey,
      kind: BookmarksEntity.kind,
    );

    final bookmarkMessage = EventMessage(
      id: id,
      tags: tags,
      createdAt: createdAt,
      content: encryptedRumor,
      pubkey: receiverPubkey,
      kind: BookmarksEntity.kind,
      sig: null,
    );

    await ionConnectNotifier.sendEvent(bookmarkMessage, cache: false);
  }

  Future<void> sendMessageReaction({
    required String eventId,
    required String reaction,
    required String receiverPubkey,
  }) async {
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    await _createSealWrapSendReaction(
      content: reaction,
      signer: eventSigner!,
      receiverPubkey: receiverPubkey,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        ['p', receiverPubkey],
        ['e', eventId],
      ],
    );
  }

  Future<void> sendMessageReceivedStatus({
    required String eventId,
    required String receiverPubkey,
  }) async {
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    await _createSealWrapSendReaction(
      signer: eventSigner!,
      content: 'received',
      receiverPubkey: receiverPubkey,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        ['p', receiverPubkey],
        ['e', eventId],
      ],
    );
  }

  Future<void> sendMessageReadStatus({
    required String lastMessageId,
    required String receiverPubkey,
  }) async {
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    await _createSealWrapSendReaction(
      signer: eventSigner!,
      content: 'read',
      receiverPubkey: receiverPubkey,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        ['p', receiverPubkey],
        ['e', lastMessageId],
      ],
    );
  }

  Future<IonConnectEntity?> _createSealWrapSendReaction({
    required String content,
    required EventSigner signer,
    required String receiverPubkey,
    required List<List<String>> tags,
    int? kind,
  }) async {
    final createdAt = DateTime.now().toUtc();

    final id = EventMessage.calculateEventId(
      tags: tags,
      content: content,
      createdAt: createdAt,
      publicKey: signer.publicKey,
      kind: PrivateMessageReactionEntity.kind,
    );

    final eventMessage = EventMessage(
      id: id,
      tags: tags,
      content: content,
      createdAt: createdAt,
      pubkey: signer.publicKey,
      kind: PrivateMessageReactionEntity.kind,
      sig: await signer.sign(message: id),
    );

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
      ),
    ).toTag();

    final wrap = await wrapService.createWrap(
      seal,
      receiverPubkey,
      PrivateMessageReactionEntity.kind,
      expirationTag: expirationTag,
    );

    final result = await ionConnectNotifier.sendEvent(wrap, cache: false);

    return result;
  }
}
