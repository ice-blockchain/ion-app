// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user_metadata/providers/user_metadata_sync_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'encrypted_deletion_request_handler.c.g.dart';

class EncryptedDeletionRequestHandler extends GlobalSubscriptionEncryptedEventMessageHandler {
  EncryptedDeletionRequestHandler(
    this.conversationMessageDao,
    this.conversationMessageReactionDao,
    this.conversationDao,
    this.eventMessageDao,
    this.env,
    this.masterPubkey,
    this.eventSigner,
    this.userMetadataSyncProvider,
  );

  final ConversationMessageDao conversationMessageDao;
  final ConversationMessageReactionDao conversationMessageReactionDao;
  final ConversationDao conversationDao;
  final EventMessageDao eventMessageDao;
  final UserMetadataSync userMetadataSyncProvider;

  final Env env;
  final String masterPubkey;
  final EventSigner eventSigner;

  @override
  bool canHandle({
    required IonConnectGiftWrapEntity entity,
  }) {
    return entity.data.kinds.containsDeep([DeletionRequestEntity.kind.toString()]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    unawaited(_deleteConversation(rumor));
    unawaited(_deleteConversationMessages(rumor));
    unawaited(userMetadataSyncProvider.syncUserMetadata(masterPubkeys: {rumor.masterPubkey}));
  }

  Future<void> _deleteConversation(EventMessage rumor) async {
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
    }
  }

  Future<void> _deleteConversationMessages(EventMessage rumor) async {
    final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

    if (eventsToDelete.isEmpty) {
      return;
    }

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
        default:
          break;
      }
    }
  }
}

@riverpod
Future<EncryptedDeletionRequestHandler?> encryptedDeletionRequestHandler(Ref ref) async {
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
  final masterPubkey = ref.watch(currentPubkeySelectorProvider);
  if (eventSigner == null || masterPubkey == null) {
    return null;
  }

  return EncryptedDeletionRequestHandler(
    ref.watch(conversationMessageDaoProvider),
    ref.watch(conversationMessageReactionDaoProvider),
    ref.watch(conversationDaoProvider),
    ref.watch(eventMessageDaoProvider),
    ref.watch(envProvider.notifier),
    masterPubkey,
    eventSigner,
    ref.watch(userMetadataSyncProvider.notifier),
  );
}
