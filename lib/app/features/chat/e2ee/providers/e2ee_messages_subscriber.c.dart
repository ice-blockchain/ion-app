// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/gift_unwrap_service_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_status_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/user_chat_relays_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_syncer_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_messages_subscriber.c.g.dart';

@Riverpod(keepAlive: true)
class E2eeMessagesSubscriber extends _$E2eeMessagesSubscriber {
  @override
  Stream<void> build() async* {
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);
    if (masterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final latestEventMessageDate = await ref
        .watch(conversationEventMessageDaoProvider)
        .getLatestEventMessageDate([ReplaceablePrivateDirectMessageEntity.kind]);

    final userChatRelays = await ref.watch(userChatRelaysProvider(masterPubkey).future);

    if (userChatRelays == null) {
      return;
    }

    final sinceDate = latestEventMessageDate?.add(const Duration(days: -2));

    final requestFilter = RequestFilter(
      limit: -1,
      kinds: const [IonConnectGiftWrapEntity.kind],
      tags: {
        '#k': [
          DeletionRequestEntity.kind.toString(),
          PrivateMessageReactionEntity.kind.toString(),
          ReplaceablePrivateDirectMessageEntity.kind.toString(),
          [GenericRepostEntity.kind.toString(), PostEntity.kind.toString()],
          [GenericRepostEntity.kind.toString(), ArticleEntity.kind.toString()],
          [GenericRepostEntity.kind.toString(), ModifiablePostEntity.kind.toString()],
        ],
        '#p': [masterPubkey],
      },
      since: sinceDate?.microsecondsSinceEpoch,
    );

    final sealService = await ref.watch(ionConnectSealServiceProvider.future);
    final giftWrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
    final sendE2eeMessageStatusService =
        await ref.watch(sendE2eeMessageStatusServiceProvider.future);
    final conversationDao = ref.watch(conversationDaoProvider);
    final eventMessageDao = ref.watch(eventMessageDaoProvider);
    final conversationMessageDao = ref.watch(conversationMessageDaoProvider);
    final conversationMessageStatusDao = ref.watch(conversationMessageDataDaoProvider);
    final conversationMessageReactionDao = ref.watch(conversationMessageReactionDaoProvider);

    await ref.watch(entitiesSyncerNotifierProvider('e2ee-messages').notifier).syncEvents(
      requestFilters: [requestFilter],
      saveCallback: (eventMessage) => _handleMessage(
        eventMessage,
        masterPubkey,
        eventSigner,
        sealService,
        giftWrapService,
        sendE2eeMessageStatusService,
        conversationDao,
        eventMessageDao,
        conversationMessageDao,
        conversationMessageStatusDao,
        conversationMessageReactionDao,
      ),
      maxCreatedAtBuilder: () => ref
          .watch(conversationEventMessageDaoProvider)
          .getLatestEventMessageDate([ReplaceablePrivateDirectMessageEntity.kind]),
      minCreatedAtBuilder: (since) =>
          ref.watch(conversationEventMessageDaoProvider).getEarliestEventMessageDate(
        [ReplaceablePrivateDirectMessageEntity.kind],
        after: since,
      ),
      overlap: const Duration(days: 2),
      actionSource: const ActionSourceCurrentUserChat(),
    );

    final requestMessage = RequestMessage()..addFilter(requestFilter);

    final events = ref.watch(
      ionConnectEventsSubscriptionProvider(
        requestMessage,
        actionSource: const ActionSourceCurrentUserChat(),
      ),
    );

    final subscription = events.listen(
      (wrap) => _handleMessage(
        wrap,
        masterPubkey,
        eventSigner,
        sealService,
        giftWrapService,
        sendE2eeMessageStatusService,
        conversationDao,
        eventMessageDao,
        conversationMessageDao,
        conversationMessageStatusDao,
        conversationMessageReactionDao,
      ),
    );

    ref.onDispose(subscription.cancel);

    yield null;
  }

  Future<void> _handleMessage(
    EventMessage eventMessage,
    String masterPubkey,
    EventSigner eventSigner,
    IonConnectSealService sealService,
    IonConnectGiftWrapService giftWrapService,
    SendE2eeMessageStatusService sendE2eeMessageStatusService,
    ConversationDao conversationDao,
    EventMessageDao eventMessageDao,
    ConversationMessageDao conversationMessageDao,
    ConversationMessageDataDao conversationMessageStatusDao,
    ConversationMessageReactionDao conversationMessageReactionDao,
  ) async {
    if (eventSigner.publicKey != _receiverDevicePubkey(eventMessage)) {
      return;
    }

    final giftUnwrapService = await ref.watch(giftUnwrapServiceProvider.future);

    final rumor = await giftUnwrapService.unwrap(eventMessage);

    if (rumor.kind == ReplaceablePrivateDirectMessageEntity.kind) {
      final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(rumor);
      final eventReference = entity.toEventReference();

      // Add conversation if that doesn't exist
      await ref.watch(conversationDaoProvider).add([rumor]);
      // Add message if that doesn't exist
      await ref.watch(conversationEventMessageDaoProvider).add(rumor);

      await _addMediaToDatabase(rumor);

      // Notify rest of the participants that the message was received
      // by the current user
      final currentStatus = await conversationMessageStatusDao.checkMessageStatus(
        eventReference: eventReference,
        masterPubkey: masterPubkey,
      );

      if (currentStatus == null || currentStatus.index < MessageDeliveryStatus.received.index) {
        await sendE2eeMessageStatusService.sendMessageStatus(
          messageEventMessage: rumor,
          status: MessageDeliveryStatus.received,
        );
      }

      // Only for kind 7
    } else if (rumor.kind == PrivateMessageReactionEntity.kind) {
      final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(rumor);

      // Identify kind 7 status message (received or read only)
      if (reactionEntity.data.content == MessageDeliveryStatus.received.name ||
          reactionEntity.data.content == MessageDeliveryStatus.read.name) {
        await conversationMessageStatusDao.addOrUpdateStatus(
          messageEventReference: reactionEntity.data.reference,
          pubkey: rumor.pubkey,
          masterPubkey: rumor.masterPubkey,
          status: MessageDeliveryStatus.values.byName(reactionEntity.data.content),
          updateAllBefore: rumor.createdAt.toDateTime,
        );
      } else {
        await conversationMessageReactionDao.add(
          ref: ref,
          reactionEvent: rumor,
        );
      }
    }
    // For kind 5
    else if (rumor.kind == DeletionRequestEntity.kind) {
      final deleteConversationIds = rumor.tags
          .where((tags) => tags[0] == ConversationIdentifier.tagName)
          .map((tag) => tag.elementAtOrNull(1))
          .nonNulls
          .toList();

      if (deleteConversationIds.isNotEmpty) {
        await ref.watch(conversationDaoProvider).removeConversations(
              ref: ref,
              deleteRequest: rumor,
              conversationIds: deleteConversationIds,
            );
      } else {
        final eventsToDelete = DeletionRequest.fromEventMessage(rumor).events;

        final eventToDeleteReferences =
            eventsToDelete.map((event) => (event as EventToDelete).eventReference).toList();

        for (final eventReference in eventToDeleteReferences) {
          switch (eventReference) {
            case ReplaceableEventReference():
              await conversationMessageDao.removeMessages(
                ref: ref,
                deleteRequest: rumor,
                eventReferences: [eventReference],
              );
            case ImmutableEventReference():
              await conversationMessageReactionDao.remove(
                ref: ref,
                reactionEventReference: eventReference,
              );
          }
        }
      }
    } else if (rumor.kind == GenericRepostEntity.kind) {
      await eventMessageDao.add(rumor);
    }
  }

  String _receiverDevicePubkey(EventMessage wrap) {
    final senderPubkey = wrap.tags.firstWhereOrNull((tags) => tags[0] == 'p')?.elementAtOrNull(3);

    if (senderPubkey == null) {
      throw ReceiverDevicePubkeyNotFoundException(wrap.id);
    }

    return senderPubkey;
  }

  Future<void> _addMediaToDatabase(
    EventMessage rumor,
  ) async {
    final entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(rumor);
    if (entity.data.media.isNotEmpty) {
      for (final media in entity.data.media.values) {
        await ref
            .read(mediaEncryptionServiceProvider)
            .retrieveEncryptedMedia(media, authorPubkey: rumor.masterPubkey);
        final isThumb =
            entity.data.media.values.any((m) => m.url != media.url && m.thumb == media.url);

        if (isThumb) {
          continue;
        }
        await ref.watch(messageMediaDaoProvider).add(
              eventReference: entity.toEventReference(),
              status: MessageMediaStatus.completed,
              remoteUrl: media.url,
            );
      }
    }
  }
}
