// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.f.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/master_pubkey_tag.f.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.r.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.r.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.r.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.f.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_feed_item_to_chat_provider.r.g.dart';

@riverpod
class ShareFeedItemToChat extends _$ShareFeedItemToChat {
  @override
  FutureOr<void> build() {}

  Future<void> share({
    required EventReference eventReference,
    required List<String> receiversMasterPubkeys,
  }) async {
    await AsyncValue.guard(
      () async {
        state = const AsyncLoading();
        final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

        if (eventSigner == null) {
          throw EventSignerNotFoundException();
        }

        final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

        if (currentUserMasterPubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }

        final sendChatMessageService = ref.read(sendE2eeChatMessageServiceProvider);

        final feedItemEntity =
            ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));

        final feedItemEventMessage = await switch (feedItemEntity) {
          final ModifiablePostEntity entity => entity.toEntityEventMessage(),
          final ArticleEntity entity => entity.toEntityEventMessage(),
          _ => throw EntityNotFoundException(eventReference),
        };

        final feedItemAsContent = jsonEncode(feedItemEventMessage.toJson().last);

        await Future.wait(receiversMasterPubkeys.map((masterPubkey) async {
          final existingConversationId =
              await ref.read(existChatConversationIdProvider(masterPubkey).future);

          final conversationId = existingConversationId ??
              sendChatMessageService.generateConversationId(receiverPubkey: masterPubkey);

          final tags = [
            MasterPubkeyTag(value: currentUserMasterPubkey).toTag(),
            ['k', feedItemEventMessage.kind.toString()],
            [RelatedPubkey.tagName, eventSigner.publicKey],
            [ConversationIdentifier.tagName, conversationId],
            eventReference.toTag(),
          ];

          final id = EventMessage.calculateEventId(
            tags: tags,
            content: feedItemAsContent,
            kind: GenericRepostEntity.kind,
            publicKey: eventSigner.publicKey,
            createdAt: DateTime.now().microsecondsSinceEpoch,
          );

          final kind16Rumor = EventMessage(
            id: id,
            tags: tags,
            content: feedItemAsContent,
            pubkey: eventSigner.publicKey,
            kind: GenericRepostEntity.kind,
            createdAt: feedItemEventMessage.createdAt,
            sig: null,
          );

          final participantsMasterPubkeys = [masterPubkey, currentUserMasterPubkey];

          final conversationPubkeysNotifier = ref.read(conversationPubkeysProvider.notifier);

          final participantsKeysMap =
              await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

          await ref.read(eventMessageDaoProvider).add(kind16Rumor);
          final kind16Entity = GenericRepostEntity.fromEventMessage(kind16Rumor);

          await Future.wait(
            participantsMasterPubkeys.map(
              (masterPubkey) async {
                final pubkeys = participantsKeysMap[masterPubkey];

                if (pubkeys == null) {
                  throw UserPubkeyNotFoundException(masterPubkey);
                }

                await Future.wait(
                  pubkeys.map((pubkey) async {
                    try {
                      await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                            pubkey: pubkey,
                            masterPubkey: masterPubkey,
                            status: MessageDeliveryStatus.created,
                            messageEventReference: kind16Entity.toEventReference(),
                          );

                      await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
                        pubkey: pubkey,
                        eventSigner: eventSigner,
                        eventMessage: kind16Rumor,
                        masterPubkey: masterPubkey,
                        wrappedKinds: [
                          GenericRepostEntity.kind.toString(),
                          feedItemEventMessage.kind.toString(),
                        ],
                      );

                      await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                            pubkey: pubkey,
                            masterPubkey: masterPubkey,
                            status: MessageDeliveryStatus.sent,
                            messageEventReference: kind16Entity.toEventReference(),
                          );
                    } catch (e) {
                      await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                            pubkey: pubkey,
                            masterPubkey: masterPubkey,
                            status: MessageDeliveryStatus.failed,
                            messageEventReference: kind16Entity.toEventReference(),
                          );
                    }
                  }),
                );
              },
            ),
          );

          await ref.read(sendE2eeChatMessageServiceProvider).sendMessage(
                content: '',
                conversationId: conversationId,
                participantsMasterPubkeys: participantsMasterPubkeys,
                quotedEvent: QuotedImmutableEvent(
                  eventReference: ImmutableEventReference(
                    eventId: kind16Rumor.id,
                    kind: GenericRepostEntity.kind,
                    masterPubkey: kind16Rumor.masterPubkey,
                  ),
                ),
              );
        }));
      },
    );
  }

  Future<void> resendPost(EventMessage kind30014Rumor) async {
    final kind30014Entity = ReplaceablePrivateDirectMessageEntity.fromEventMessage(kind30014Rumor);

    await _resendKind16(kind30014Entity);

    await ref.read(sendE2eeChatMessageServiceProvider).resendMessage(eventMessage: kind30014Rumor);
  }

  Future<void> _resendKind16(ReplaceablePrivateDirectMessageEntity feedItemEntity) async {
    final kind16Rumor = await ref
        .read(eventMessageDaoProvider)
        .getByReference(feedItemEntity.data.quotedEvent!.eventReference);

    final kind16Entity = GenericRepostEntity.fromEventMessage(kind16Rumor);
    final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final failedKind16Participants = await ref
        .read(conversationMessageDataDaoProvider)
        .getFailedParticipants(eventReference: kind16Entity.toEventReference());

    if (failedKind16Participants.isNotEmpty) {
      for (final masterPubkey in failedKind16Participants.keys) {
        final pubkeys = failedKind16Participants[masterPubkey];

        if (pubkeys == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        for (final pubkey in pubkeys) {
          try {
            await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                  pubkey: pubkey,
                  masterPubkey: masterPubkey,
                  status: MessageDeliveryStatus.created,
                  messageEventReference: kind16Entity.toEventReference(),
                );

            await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
              pubkey: pubkey,
              eventSigner: eventSigner,
              masterPubkey: masterPubkey,
              eventMessage: kind16Rumor,
              wrappedKinds: [
                GenericRepostEntity.kind.toString(),
                ModifiablePostEntity.kind.toString(),
              ],
            );

            await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                  pubkey: pubkey,
                  masterPubkey: masterPubkey,
                  status: MessageDeliveryStatus.sent,
                  messageEventReference: kind16Entity.toEventReference(),
                );
          } catch (e) {
            await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                  pubkey: pubkey,
                  masterPubkey: masterPubkey,
                  status: MessageDeliveryStatus.failed,
                  messageEventReference: kind16Entity.toEventReference(),
                );
          }
        }
      }
    }
  }
}
