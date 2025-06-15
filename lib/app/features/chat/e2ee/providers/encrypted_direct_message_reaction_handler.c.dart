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

class EncryptedDirectMessageReactionHandler
    extends PersistentSubscriptionEncryptedEventMessageHandler {
  EncryptedDirectMessageReactionHandler(
    this.conversationMessageReactionDao,
    this.eventMessageDao,
  );

  final ConversationMessageReactionDao conversationMessageReactionDao;
  final EventMessageDao eventMessageDao;

  @override
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  }) {
    return entity.data.kinds.containsDeep([
      PrivateMessageReactionEntity.kind.toString(),
      PrivateMessageReactionEntity.kind.toString(),
    ]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    await conversationMessageReactionDao.add(
      reactionEvent: rumor,
      eventMessageDao: eventMessageDao,
    );
  }
}

@riverpod
EncryptedDirectMessageReactionHandler encryptedDirectMessageReactionHandler(Ref ref) =>
    EncryptedDirectMessageReactionHandler(
      ref.watch(conversationMessageReactionDaoProvider),
      ref.watch(eventMessageDaoProvider),
    );
