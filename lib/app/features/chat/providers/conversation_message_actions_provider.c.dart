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
import 'package:ion/app/features/nostr/model/entity_expiration.c.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/nostr/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_seal_service.c.dart';
import 'package:nip44/nip44.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_message_actions_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<Raw<ConversationMessageActionsService>> conversationMessageActionsService(
  Ref ref,
) async {
  final databaseService = ref.watch(conversationsDBServiceProvider);
  final conversationMessageManagementService =
      ref.watch(conversationMessageManagementServiceProvider).requireValue;

  final eventSigner = await ref.watch(currentUserNostrEventSignerProvider.future);

  return ConversationMessageActionsService(
    eventSigner: eventSigner,
    databaseService: databaseService,
    env: ref.watch(envProvider.notifier),
    userPubkey: await ref.watch(currentPubkeySelectorProvider.future),
    sealService: ref.watch(ionConnectSealServiceProvider),
    nostrNotifier: ref.watch(nostrNotifierProvider.notifier),
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
    required this.nostrNotifier,
    required this.databaseService,
    required this.conversationMessageManagementService,
  });

  final Env env;
  final String? userPubkey;
  final EventSigner? eventSigner;
  final NostrNotifier nostrNotifier;
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
      ['d', 'chat_messages'],
      ['encrypted'],
    ];

    Logger.log('Encoded rumor $encodedRumor');

    final encryptedRumor = await Nip44.encryptMessage(
      encodedRumor,
      eventSigner!.privateKey,
      receiverPubkey,
    );

    Logger.log('Encrypted rumor $encryptedRumor');

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

    Logger.log('Bookmark message $bookmarkMessage');

    await nostrNotifier.sendEvent(bookmarkMessage, cache: false);
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

  Future<NostrEntity?> _createSealWrapSendReaction({
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

    Logger.log('Event message $eventMessage');

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    Logger.log('Seal message $seal');

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
      ),
    ).toTag();

    final wrap = await wrapService.createWrap(
      seal,
      receiverPubkey,
      signer,
      PrivateMessageReactionEntity.kind,
      expirationTag: expirationTag,
    );

    Logger.log('Wrap message $wrap');

    final result = await nostrNotifier.sendEvent(wrap, cache: false);

    Logger.log('Sent message $result');

    return result;
  }
}
