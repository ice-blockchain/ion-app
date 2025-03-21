// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_saver/file_saver.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_chat_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_chat_message_provider.c.g.dart';

@riverpod
class SendChatMessageNotifier extends _$SendChatMessageNotifier {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> sendMessage({
    required String conversationId,
    required List<String> participantsMasterPubkeys,
    required String content,
    required List<MediaFile> mediaFiles,
    String? subject,
    List<String>? groupImageTag,
    String? failedEventMessageId,
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

      await ref.read(conversationDaoProvider).add([eventMessage]);
      await ref.read(conversationEventMessageDaoProvider).add(eventMessage);
      await ref.read(conversationMessageDataDaoProvider).add(
            masterPubkey: currentUserMasterPubkey,
            eventMessageId: eventMessage.id,
            status: MessageDeliveryStatus.created,
          );

      final mediaAttachmentsUsersBased = await _sendMediaFiles(
        mediaFiles,
        failedParticipantsMasterPubkeys ?? participantsMasterPubkeys,
        eventMessage.id,
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
                conversationId: conversationId,
                masterPubkeys: participantsMasterPubkeys,
                subject: subject,
                groupImageTag: groupImageTag,
              ),
              if (mediaTags != null) ...mediaTags,
            ];

            final isCurrentUser = ref.read(isCurrentUserSelectorProvider(masterPubkey));
            final event = await _createEventMessage(
              content: content,
              signer: eventSigner,
              tags: conversationTagsWithMediaTags,
              previousId: isCurrentUser ? eventMessage.id : null,
            );

            // if (isCurrentUser) {
            //   throw Exception('test');
            // }

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

  Future<Map<String, List<MediaAttachment>>> _sendMediaFiles(
    List<MediaFile> mediaFiles,
    List<String> participantsMasterPubkeys,
    String eventMessageId,
  ) async {
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

    final eventMessageIds = await ref.read(messageMediaDaoProvider).addBatch(
          eventMessageId: eventMessageId,
          cacheKeys: cacheKeys,
        );

    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);
    final mediaAttachmentsUsersBased = <String, List<MediaAttachment>>{};

    final mediaAttachmentsFutures = mediaFiles.map(
      (mediaFile) async {
        final indexOfMediaFile = mediaFiles.indexOf(mediaFile);
        final id = eventMessageIds[indexOfMediaFile];

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
    required EventSigner eventSigner,
    required String pubkey,
    required String masterPubkey,
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
  }) {
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);

    final tags = [
      if (subject != null) ['subject', subject],
      ...masterPubkeys.map((pubkey) => ['p', pubkey]),
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
}
