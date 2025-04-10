// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_chat_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_chat_message_service.c.g.dart';

@riverpod
SendE2eeChatMessageService sendE2eeChatMessageService(Ref ref) {
  return SendE2eeChatMessageService(ref);
}

class SendE2eeChatMessageService {
  SendE2eeChatMessageService(this.ref);

  final Ref ref;

  Future<void> sendMessage({
    required String conversationId,
    required List<String> participantsMasterPubkeys,
    required String content,
    required List<MediaFile> mediaFiles,
    String? subject,
    List<String>? groupImageTag,
    String? failedEventMessageId,
    EventMessage? repliedMessage,
    List<String>? failedParticipantsMasterPubkeys,
  }) async {
    String? currentUserEventMessageId;

    try {
      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

      if (currentUserMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final conversationTags = _generateConversationTags(
        subject: subject,
        groupImageTag: groupImageTag,
        conversationId: conversationId,
        repliedMessage: repliedMessage,
        masterPubkeys: participantsMasterPubkeys,
      );

      final mediaAttachments = mediaFiles.map((m) {
        return MediaAttachment.fromMediaFile(m);
      }).toList();

      final eventMessage = await _createEventMessage(
        content: content,
        signer: eventSigner,
        tags: conversationTags..addAll(mediaAttachments.map((a) => a.toTag())),
        previousId: failedEventMessageId,
      );

      currentUserEventMessageId = eventMessage.id;

      final messageMediaIds = await _addDbEntities(
        eventMessage,
        mediaFiles,
      );

      final mediaAttachmentsUsersBased = await _sendMediaFiles(
        mediaFiles,
        failedParticipantsMasterPubkeys ?? participantsMasterPubkeys,
        eventMessage.id,
        messageMediaIds,
      );

      final participantsKeysMap = await ref
          .read(conversationPubkeysProvider.notifier)
          .fetchUsersKeys(failedParticipantsMasterPubkeys ?? participantsMasterPubkeys);

      participantsMasterPubkeys.sort((a, b) {
        if (a == currentUserMasterPubkey) return 1;
        if (b == currentUserMasterPubkey) return -1;
        return a.compareTo(b);
      });

      await Future.wait(
        participantsMasterPubkeys.map((masterPubkey) async {
          try {
            final pubkey = participantsKeysMap[masterPubkey];
            if (pubkey == null) throw UserPubkeyNotFoundException(masterPubkey);

            final attachments = mediaAttachmentsUsersBased[masterPubkey];
            final mediaTags = attachments?.map((a) => a.toTag()).toList();

            final conversationTagsWithMediaTags = [
              ..._generateConversationTags(
                subject: subject,
                groupImageTag: groupImageTag,
                conversationId: conversationId,
                repliedMessage: repliedMessage,
                masterPubkeys: participantsMasterPubkeys,
              ),
              if (mediaTags != null) ...mediaTags,
            ];

            final isCurrentUser = ref.read(isCurrentUserSelectorProvider(masterPubkey));
            final event = await _createEventMessage(
              content: content,
              signer: eventSigner,
              tags: conversationTagsWithMediaTags,
              previousId: eventMessage.id,
            );

            await _sendKind14Message(
              eventMessage: event,
              eventSigner: eventSigner,
              pubkey: pubkey,
              masterPubkey: masterPubkey,
            );

            await ref.read(conversationMessageDataDaoProvider).add(
                  masterPubkey: masterPubkey,
                  eventMessageId: currentUserEventMessageId!,
                  status: isCurrentUser ? MessageDeliveryStatus.read : MessageDeliveryStatus.sent,
                );
          } catch (e) {
            if (currentUserEventMessageId != null) {
              await ref.read(conversationMessageDataDaoProvider).add(
                    masterPubkey: masterPubkey,
                    eventMessageId: currentUserEventMessageId,
                    status: MessageDeliveryStatus.failed,
                  );
            }
          }
        }),
      );
    } catch (e) {
      if (currentUserEventMessageId != null) {
        for (final pubkey in participantsMasterPubkeys) {
          await ref.read(conversationMessageDataDaoProvider).add(
                masterPubkey: pubkey,
                eventMessageId: currentUserEventMessageId,
                status: MessageDeliveryStatus.failed,
              );
        }
      }
      throw SendEventException(e.toString());
    }
  }

  List<RelatedEvent> _buildRelatedEvents(EventMessage? repliedMessage) {
    if (repliedMessage != null) {
      final entity = PrivateDirectMessageEntity.fromEventMessage(repliedMessage);

      final rootRelatedEvent = entity.data.relatedEvents
          ?.firstWhereOrNull((tag) => tag.marker == RelatedEventMarker.root);

      final marker = rootRelatedEvent != null ? RelatedEventMarker.reply : RelatedEventMarker.root;

      return [
        if (rootRelatedEvent != null) rootRelatedEvent,
        RelatedImmutableEvent(
          marker: marker,
          pubkey: repliedMessage.masterPubkey,
          eventReference: ImmutableEventReference(
            eventId: repliedMessage.id,
            pubkey: repliedMessage.masterPubkey,
          ),
        ),
      ];
    }

    return [];
  }

  Future<Map<String, List<MediaAttachment>>> _sendMediaFiles(
    List<MediaFile> mediaFiles,
    List<String> participantsMasterPubkeys,
    String eventMessageId,
    List<int> messageMediaIds,
  ) async {
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);
    final mediaAttachmentsUsersBased = <String, List<MediaAttachment>>{};

    final mediaAttachmentsFutures = mediaFiles.map(
      (mediaFile) async {
        final indexOfMediaFile = mediaFiles.indexOf(mediaFile);
        final id = messageMediaIds[indexOfMediaFile];

        final sendResult = await ref
            .read(sendChatMediaProvider(id).notifier)
            .sendChatMedia(participantsMasterPubkeys, mediaFile);

        final currentUserSendResult =
            sendResult.firstWhereOrNull((a) => a.$1 == currentUserMasterPubkey);
        if (currentUserSendResult == null) {
          return sendResult;
        }

        await ref.read(messageMediaDaoProvider).updateById(
              id,
              eventMessageId,
              currentUserSendResult.$2.first.url,
              MessageMediaStatus.completed,
            );

        return sendResult;
      },
    ).toList();

    final mediaAttachmentsLists = await Future.wait(mediaAttachmentsFutures);

    for (final mediaAttachments in mediaAttachmentsLists) {
      for (final (pubkey, attachment) in mediaAttachments) {
        mediaAttachmentsUsersBased.update(
          pubkey,
          (attachments) => [...attachments, ...attachment],
          ifAbsent: () => attachment,
        );
      }
    }

    return mediaAttachmentsUsersBased;
  }

  Future<void> _sendKind14Message({
    required String pubkey,
    required String masterPubkey,
    required EventSigner eventSigner,
    required EventMessage eventMessage,
  }) async {
    final giftWrap = await _createGiftWrap(
      signer: eventSigner,
      receiverPubkey: pubkey,
      eventMessage: eventMessage,
      receiverMasterPubkey: masterPubkey,
    );

    await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
          giftWrap,
          cache: false,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
        );
  }

  List<List<String>> _generateConversationTags({
    required String conversationId,
    required List<String> masterPubkeys,
    String? subject,
    List<String>? groupImageTag,
    EventMessage? repliedMessage,
  }) {
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    final relatedEventsTags = _buildRelatedEvents(repliedMessage).map((tag) => tag.toTag());

    final tags = [
      if (subject != null) ['subject', subject],
      ...masterPubkeys.map((pubkey) => ['p', pubkey]),
      ...relatedEventsTags,
      [CommunityIdentifierTag.tagName, conversationId],
      if (groupImageTag != null) groupImageTag,
      ['b', currentUserMasterPubkey!],
    ];

    return tags;
  }

  Future<EventMessage> _createEventMessage({
    required String content,
    required EventSigner signer,
    required List<List<String>> tags,
    String? previousId,
    int kind = PrivateDirectMessageEntity.kind,
  }) async {
    final createdAt = DateTime.now().toUtc();

    final id = previousId ??
        EventMessage.calculateEventId(
          tags: tags,
          kind: kind,
          content: content,
          createdAt: createdAt,
          publicKey: signer.publicKey,
        );

    final eventMessage = EventMessage(
      id: id,
      tags: tags,
      kind: kind,
      content: content,
      createdAt: createdAt,
      pubkey: signer.publicKey,
      sig: null,
    );

    return eventMessage;
  }

  Future<EventMessage> _createGiftWrap({
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required EventSigner signer,
    required EventMessage eventMessage,
    int kind = PrivateDirectMessageEntity.kind,
  }) async {
    final env = ref.read(envProvider.notifier);
    final sealService = await ref.read(ionConnectSealServiceProvider.future);
    final wrapService = await ref.read(ionConnectGiftWrapServiceProvider.future);

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS)),
      ),
    ).toTag();

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    final wrap = await wrapService.createWrap(
      event: seal,
      contentKind: kind,
      receiverPubkey: receiverPubkey,
      receiverMasterPubkey: receiverMasterPubkey,
      expirationTag: expirationTag,
    );

    return wrap;
  }

  Future<void> resendMessage({
    required EventMessage messageEvent,
  }) async {
    final entity = PrivateDirectMessageEntity.fromEventMessage(messageEvent);

    final messageStatuses =
        await ref.read(conversationMessageDataDaoProvider).messageStatuses(messageEvent.id);

    final failedParticipantsMasterPubkeysMap = messageStatuses
      ..removeWhere((key, value) => value != MessageDeliveryStatus.failed);

    final failedParticipantsMasterPubkeys = failedParticipantsMasterPubkeysMap.keys.toList();

    final mediaFiles = entity.data.media.values
        .map(
          (media) => MediaFile(
            path: media.url,
            mimeType: media.mimeType,
            height: int.parse(media.dimension.split('x').first),
            width: int.parse(media.dimension.split('x').last),
          ),
        )
        .toList();

    await sendMessage(
      mediaFiles: mediaFiles,
      content: messageEvent.content,
      conversationId: entity.data.uuid,
      failedEventMessageId: messageEvent.id,
      participantsMasterPubkeys: entity.allPubkeys,
      failedParticipantsMasterPubkeys: failedParticipantsMasterPubkeys,
    );
  }

  String generateConversationId({
    required String receiverPubkey,
  }) {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final sorted = [receiverPubkey, currentPubkey]..sort();
    return sorted.join();
  }

  Future<List<String>> _generateCacheKeys(List<MediaFile> mediaFiles) async {
    final cacheKeys = <String>[];

    for (final mediaFile in mediaFiles) {
      final file = File(mediaFile.path);
      final fileName = generateUuid();
      final isVideo = MediaType.fromMimeType(mediaFile.mimeType ?? '') == MediaType.video;

      if (isVideo) {
        final thumb = await ref.read(compressServiceProvider).getThumbnail(mediaFile);
        await FileSaver.instance.saveFileOnly(name: fileName, file: File(thumb.path));
      } else {
        await FileSaver.instance.saveFileOnly(name: fileName, file: file);
      }
      cacheKeys.add(fileName);
    }

    return cacheKeys;
  }

  Future<List<int>> _addDbEntities(
    EventMessage eventMessage,
    List<MediaFile> mediaFiles,
  ) async {
    final cacheKeys = await _generateCacheKeys(mediaFiles);

    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    var messageMediaIds = <int>[];
    await ref.read(chatDatabaseProvider).transaction(() async {
      await ref.read(conversationDaoProvider).add([eventMessage]);
      await ref.read(conversationEventMessageDaoProvider).add(eventMessage);
      await ref.read(conversationMessageDataDaoProvider).add(
            masterPubkey: currentUserMasterPubkey!,
            eventMessageId: eventMessage.id,
            status: MessageDeliveryStatus.created,
          );

      messageMediaIds = await ref.read(messageMediaDaoProvider).addBatch(
            eventMessageId: eventMessage.id,
            cacheKeys: cacheKeys,
          );
    });

    return messageMediaIds;
  }
}
