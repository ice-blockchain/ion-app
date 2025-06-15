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

part 'encrypted_direct_message_status_handler.c.g.dart';

class EncryptedDirectMessageStatusHandler
    extends PersistentSubscriptionEncryptedEventMessageHandler {
  EncryptedDirectMessageStatusHandler(
    this.conversationMessageDataDao,
  );

  final ConversationMessageDataDao conversationMessageDataDao;

  @override
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  }) {
    return entity.data.kinds.containsDeep([
          PrivateMessageReactionEntity.kind.toString(),
        ]) &&
        (entity.data.content == MessageDeliveryStatus.received.name ||
            entity.data.content == MessageDeliveryStatus.read.name);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final entity = PrivateMessageReactionEntity.fromEventMessage(rumor);
    await conversationMessageDataDao.addOrUpdateStatus(
      messageEventReference: entity.data.reference,
      pubkey: rumor.pubkey,
      masterPubkey: rumor.masterPubkey,
      status: MessageDeliveryStatus.values.byName(entity.data.content),
      updateAllBefore: rumor.createdAt.toDateTime,
    );
  }
}

@riverpod
EncryptedDirectMessageStatusHandler encryptedDirectMessageStatusHandler(Ref ref) =>
    EncryptedDirectMessageStatusHandler(
      ref.watch(conversationMessageDataDaoProvider),
    );
