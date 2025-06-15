// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_encrypted_event_message_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_direct_message_reaction_handler.c.g.dart';

class EncryptedDirectMessageReactionEventHandler
    extends PersistentSubscriptionEncryptedEventMessageHandler {
  EncryptedDirectMessageReactionEventHandler(
    this.conversationMessageDataDao,
    this.conversationMessageReactionDao,
    this.eventMessageDao,
  );

  final ConversationMessageDataDao conversationMessageDataDao;
  final ConversationMessageReactionDao conversationMessageReactionDao;
  final EventMessageDao eventMessageDao;

  @override
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  }) {
    return entity.data.kinds.containsDeep([
          PrivateMessageReactionEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
        ]) ||
        entity.data.kinds.containsDeep([
          PrivateMessageReactionEntity.kind.toString(),
        ]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(rumor);

    // Identify kind 7 status message (received or read only)
    if (reactionEntity.data.content == MessageDeliveryStatus.received.name ||
        reactionEntity.data.content == MessageDeliveryStatus.read.name) {
      await conversationMessageDataDao.addOrUpdateStatus(
        messageEventReference: reactionEntity.data.reference,
        pubkey: rumor.pubkey,
        masterPubkey: rumor.masterPubkey,
        status: MessageDeliveryStatus.values.byName(reactionEntity.data.content),
        updateAllBefore: rumor.createdAt.toDateTime,
      );
    } else {
      await conversationMessageReactionDao.add(
        reactionEvent: rumor,
        eventMessageDao: eventMessageDao,
      );
    }
  }
}

@riverpod
EncryptedDirectMessageReactionEventHandler encryptedDirectMessageReactionEventHandler(Ref ref) =>
    EncryptedDirectMessageReactionEventHandler(
      ref.watch(conversationMessageDataDaoProvider),
      ref.watch(conversationMessageReactionDaoProvider),
      ref.watch(eventMessageDaoProvider),
    );
