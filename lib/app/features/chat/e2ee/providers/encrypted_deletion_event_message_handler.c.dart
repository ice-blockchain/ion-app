// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_deletion_event_message_handler.c.g.dart';

class EncryptedDeletionRequestEventHandler
    extends PersistentSubscriptionEncryptedEventMessageHandler {
  EncryptedDeletionRequestEventHandler(
    this.conversationMessageDao,
    this.conversationMessageReactionDao,
    this.conversationDao,
    this.eventMessageDao,
    this.env,
    this.masterPubkey,
    this.eventSigner,
  );

  final ConversationMessageDao conversationMessageDao;
  final ConversationMessageReactionDao conversationMessageReactionDao;
  final ConversationDao conversationDao;
  final EventMessageDao eventMessageDao;
  final Env env;
  final String masterPubkey;
  final EventSigner eventSigner;

  @override
  bool canHandle({
    required List<String> wrappedKinds,
    List<String> wrappedSecondKinds = const [],
  }) {
    return wrappedKinds.contains(
      DeletionRequestEntity.kind.toString(),
    );
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final deleteConversationIds = rumor.tags
        .where((tags) => tags[0] == ConversationIdentifier.tagName)
        .map((tag) => tag.elementAtOrNull(1))
        .nonNulls
        .toList();

    if (deleteConversationIds.isNotEmpty) {
      await conversationDao.removeConversations(
        deleteRequest: rumor,
        conversationIds: deleteConversationIds,
        eventMessageDao: eventMessageDao,
      );
    } else {
      final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

      final eventToDeleteReferences =
          eventsToDelete.map((event) => (event as EventToDelete).eventReference).toList();

      for (final eventReference in eventToDeleteReferences) {
        switch (eventReference) {
          case ReplaceableEventReference():
            await conversationMessageDao.removeMessages(
              deleteRequest: rumor,
              eventReferences: [eventReference],
              env: env,
              masterPubkey: masterPubkey,
              eventSignerPubkey: eventSigner.publicKey,
            );
          case ImmutableEventReference():
            await conversationMessageReactionDao.remove(
              reactionEventReference: eventReference,
            );
        }
      }
    }
  }
}

@riverpod
Future<EncryptedDeletionRequestEventHandler> encryptedDeletionRequestEventHandler(Ref ref) async {
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  if (eventSigner == null) {
    throw EventSignerNotFoundException();
  }

  final masterPubkey = ref.watch(currentPubkeySelectorProvider);

  if (masterPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return EncryptedDeletionRequestEventHandler(
    ref.watch(conversationMessageDaoProvider),
    ref.watch(conversationMessageReactionDaoProvider),
    ref.watch(conversationDaoProvider),
    ref.watch(eventMessageDaoProvider),
    ref.watch(envProvider.notifier),
    masterPubkey,
    eventSigner,
  );
}
