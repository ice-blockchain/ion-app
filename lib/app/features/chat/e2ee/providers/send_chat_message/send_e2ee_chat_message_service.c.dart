// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/conversation_identifier.c.dart';
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
import 'package:ion/app/features/ion_connect/model/replaceable_event_identifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/compressors/video_compressor.c.dart';
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

  Future<EventMessage> sendMessage({
    required String content,
    required String conversationId,
    required List<MediaFile> mediaFiles,
    required List<String> participantsMasterPubkeys,
    int kind = ReplaceablePrivateDirectMessageEntity.kind,
    String? subject,
    String? existingSharedId,
    String? failedEventMessageId,
    EventMessage? repliedMessage,
    List<String>? groupImageTag,
    List<String>? referencePostTag,
    List<String>? failedParticipantsMasterPubkeys,
  }) async {
    EventMessage? sentMessage;

    final sharedId = existingSharedId ?? generateUuid();

    final participantsPubkeysMap = await ref
        .read(conversationPubkeysProvider.notifier)
        .fetchUsersKeys(failedParticipantsMasterPubkeys ?? participantsMasterPubkeys);

    try {
      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

      if (currentUserMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final localMediaTags =
          mediaFiles.map(MediaAttachment.fromMediaFile).map((a) => a.toTag()).toList();

      final conversationTagsWithLocalMedia = _generateConversationTags(
        subject: subject,
        messageId: sharedId,
        mediaTags: localMediaTags,
        groupImageTag: groupImageTag,
        conversationId: conversationId,
        repliedMessage: repliedMessage,
        referencePostTag: referencePostTag,
        masterPubkeys: participantsMasterPubkeys,
      );

      final localEventMessage = await _createEventMessage(
        kind: kind,
        isLocal: true,
        content: content,
        signer: eventSigner,
        tags: conversationTagsWithLocalMedia,
        failedEventMessageId: failedEventMessageId,
      );

      sentMessage = localEventMessage;

      final messageMediaIds = await _addDbEntities(
        sharedId: sharedId,
        mediaFiles: mediaFiles,
        localEventMessage: localEventMessage,
      );

      final mediaAttachmentsUsersBased = await _sendMediaFiles(
        mediaFiles: mediaFiles,
        messageMediaIds: messageMediaIds,
        eventMessageId: localEventMessage.id,
        participantsMasterPubkeys: failedParticipantsMasterPubkeys ?? participantsMasterPubkeys,
      );

      participantsMasterPubkeys.sort((a, b) {
        if (a == currentUserMasterPubkey) return 1;
        if (b == currentUserMasterPubkey) return -1;
        return a.compareTo(b);
      });

      await Future.wait(
        participantsMasterPubkeys.map((masterPubkey) async {
          final pubkey = participantsPubkeysMap[masterPubkey];
          try {
            if (pubkey == null) throw UserPubkeyNotFoundException(masterPubkey);

            final attachments = mediaAttachmentsUsersBased[masterPubkey];
            final mediaTagsWithRemoteMedia = attachments?.map((a) => a.toTag()).toList();

            final conversationTagsWithRemoteMedia = _generateConversationTags(
              subject: subject,
              messageId: sharedId,
              groupImageTag: groupImageTag,
              conversationId: conversationId,
              repliedMessage: repliedMessage,
              referencePostTag: referencePostTag,
              mediaTags: mediaTagsWithRemoteMedia,
              masterPubkeys: participantsMasterPubkeys,
            );

            final isCurrentUser = ref.read(isCurrentUserSelectorProvider(masterPubkey));

            final remoteEventMessage = await _createEventMessage(
              kind: kind,
              content: content,
              signer: eventSigner,
              tags: conversationTagsWithRemoteMedia,
              failedEventMessageId: failedEventMessageId,
            );

            await sendWrappedMessage(
              pubkey: pubkey,
              eventSigner: eventSigner,
              masterPubkey: masterPubkey,
              wrappedKinds: [kind.toString()],
              eventMessage: remoteEventMessage,
            );

            await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                  pubkey: pubkey,
                  sharedId: sharedId,
                  masterPubkey: masterPubkey,
                  status: isCurrentUser ? MessageDeliveryStatus.read : MessageDeliveryStatus.sent,
                );
          } catch (e) {
            if (pubkey != null) {
              await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                    pubkey: pubkey,
                    sharedId: sharedId,
                    masterPubkey: masterPubkey,
                    status: MessageDeliveryStatus.failed,
                  );
            }
          }
        }),
      );
    } catch (e) {
      for (final masterPubkey in participantsMasterPubkeys) {
        final pubkey = participantsPubkeysMap[masterPubkey];

        if (pubkey != null && sentMessage != null) {
          await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
                pubkey: pubkey,
                sharedId: sharedId,
                masterPubkey: masterPubkey,
                status: MessageDeliveryStatus.failed,
              );
        }
      }
      throw SendEventException(e.toString());
    }

    return sentMessage;
  }

  List<RelatedEvent> _generateRelatedEvents(EventMessage? repliedMessage) {
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

  Future<Map<String, List<MediaAttachment>>> _sendMediaFiles({
    required String eventMessageId,
    required List<int> messageMediaIds,
    required List<MediaFile> mediaFiles,
    required List<String> participantsMasterPubkeys,
  }) async {
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

  Future<void> sendWrappedMessage({
    required String pubkey,
    required String masterPubkey,
    required EventSigner eventSigner,
    required EventMessage eventMessage,
    required List<String> wrappedKinds,
  }) async {
    final giftWrap = await _createGiftWrap(
      signer: eventSigner,
      kinds: wrappedKinds,
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
    String? messageId,
    List<String>? groupImageTag,
    List<List<String>>? mediaTags,
    List<String>? referencePostTag,
    EventMessage? repliedMessage,
  }) {
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    final relatedEventsTags = _generateRelatedEvents(repliedMessage).map((tag) => tag.toTag());

    final tags = [
      ...relatedEventsTags,
      ...masterPubkeys.map((pubkey) => ['p', pubkey]),
      [ConversationIdentifier.tagName, conversationId],
      if (mediaTags != null) ...mediaTags,
      if (subject != null) ['subject', subject],
      if (groupImageTag != null) groupImageTag,
      if (referencePostTag != null) referencePostTag,
      if (messageId != null) [ReplaceableEventIdentifier.tagName, messageId],
      ['b', currentUserMasterPubkey!],
    ];

    return tags;
  }

  Future<EventMessage> _createEventMessage({
    required int kind,
    required String content,
    required EventSigner signer,
    required List<List<String>> tags,
    bool isLocal = false,
    String? failedEventMessageId,
  }) async {
    final createdAt =
        isLocal ? DateTime.now().subtract(const Duration(seconds: 1)) : DateTime.now();

    final id = failedEventMessageId ??
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
    required List<String> kinds,
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required EventSigner signer,
    required EventMessage eventMessage,
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
      contentKinds: kinds,
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

    final messageStatuses = await ref.read(conversationMessageDataDaoProvider).messageStatuses(
          sharedId: messageEvent.sharedId!,
          masterPubkey: messageEvent.masterPubkey,
        );

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
      conversationId: entity.data.conversationId,
      failedEventMessageId: messageEvent.id,
      participantsMasterPubkeys: entity.allPubkeys,
      failedParticipantsMasterPubkeys:
          failedParticipantsMasterPubkeys.isNotEmpty ? failedParticipantsMasterPubkeys : null,
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
        final thumb = await ref.read(videoCompressorProvider).getThumbnail(mediaFile);
        await FileSaver.instance.saveFileOnly(name: fileName, file: File(thumb.path));
      } else {
        await FileSaver.instance.saveFileOnly(name: fileName, file: file);
      }
      cacheKeys.add(fileName);
    }

    return cacheKeys;
  }

  Future<List<int>> _addDbEntities({
    required String sharedId,
    required List<MediaFile> mediaFiles,
    required EventMessage localEventMessage,
  }) async {
    final cacheKeys = await _generateCacheKeys(mediaFiles);

    var messageMediaIds = <int>[];
    await ref.read(chatDatabaseProvider).transaction(() async {
      await ref.read(conversationDaoProvider).add([localEventMessage]);
      await ref.read(conversationEventMessageDaoProvider).add(localEventMessage);
      await ref.read(conversationMessageDataDaoProvider).addOrUpdateStatus(
            sharedId: sharedId,
            pubkey: localEventMessage.pubkey,
            status: MessageDeliveryStatus.created,
            masterPubkey: localEventMessage.masterPubkey,
          );

      messageMediaIds = await ref.read(messageMediaDaoProvider).addBatch(
            cacheKeys: cacheKeys,
            eventMessageId: localEventMessage.id,
          );
    });

    return messageMediaIds;
  }
}
