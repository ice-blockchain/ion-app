// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_post_provider.c.g.dart';

@riverpod
class SharePost extends _$SharePost {
  @override
  FutureOr<void> build() {}

  Future<void> sharePost({
    required EventReference eventReference,
    required List<String> receiversMasterPubkeys,
  }) async {
    state = await AsyncValue.guard(
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

        final entity =
            ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));

        final postEventMessage = await entity.map((entity) {
          if (entity is ModifiablePostEntity) {
            return entity.toEntityEventMessage();
          } else if (entity is PostEntity) {
            return entity.toEventMessage(entity.data);
          }
        });

        if (entity == null || postEventMessage == null) {
          throw EntityNotFoundException(eventReference);
        }

        final postAsContent = jsonEncode(postEventMessage.toJson().last);

        for (final masterPubkey in receiversMasterPubkeys) {
          final existingConversationId =
              await ref.read(existChatConversationIdProvider(masterPubkey).future);

          final conversationId = existingConversationId ??
              sendChatMessageService.generateConversationId(receiverPubkey: masterPubkey);

          final tags = [
            ['b', currentUserMasterPubkey],
            ['k', postEventMessage.kind.toString()],
            [RelatedPubkey.tagName, eventSigner.publicKey],
            [ConversationIdentifier.tagName, conversationId],
            eventReference.toTag(),
          ];

          final id = EventMessage.calculateEventId(
            tags: tags,
            content: postAsContent,
            createdAt: DateTime.now(),
            kind: GenericRepostEntity.kind,
            publicKey: eventSigner.publicKey,
          );

          final kind16Rumor = EventMessage(
            id: id,
            tags: tags,
            content: postAsContent,
            pubkey: eventSigner.publicKey,
            kind: GenericRepostEntity.kind,
            createdAt: postEventMessage.createdAt,
            sig: null,
          );

          final participantsMasterPubkeys = [
            masterPubkey,
            currentUserMasterPubkey,
          ];

          final conversationPubkeysNotifier = ref.read(conversationPubkeysProvider.notifier);

          final participantsKeysMap =
              await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);

          for (final masterPubkey in participantsMasterPubkeys) {
            final pubkeys = participantsKeysMap[masterPubkey];

            if (pubkeys == null) {
              throw UserPubkeyNotFoundException(masterPubkey);
            }

            for (final pubkey in pubkeys) {
              await ref.read(sendE2eeChatMessageServiceProvider).sendWrappedMessage(
                pubkey: pubkey,
                eventMessage: kind16Rumor,
                eventSigner: eventSigner,
                masterPubkey: masterPubkey,
                wrappedKinds: [
                  GenericRepostEntity.kind.toString(),
                  postEventMessage.kind.toString(),
                ],
              );
            }

            await ref.read(sendE2eeChatMessageServiceProvider).sendMessage(
                  content: '',
                  conversationId: conversationId,
                  participantsMasterPubkeys: participantsMasterPubkeys,
                  quotedEvent: QuotedImmutableEvent(
                    eventReference: ImmutableEventReference(
                      eventId: kind16Rumor.id,
                      pubkey: kind16Rumor.masterPubkey,
                      kind: GenericRepostEntity.kind,
                    ),
                  ),
                );
          }
        }
      },
    );
  }
}
