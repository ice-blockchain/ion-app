// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifier_tag.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/pubkey_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_chat_message_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/file_cache/ion_file_cache_manager.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_message_provider.c.g.dart';

@riverpod
Future<SendE2eeMessageService> sendE2eeMessageService(
  Ref ref,
) async {
  final sealService = await ref.watch(ionConnectSealServiceProvider.future);
  final wrapService = await ref.watch(ionConnectGiftWrapServiceProvider.future);
  final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

  return SendE2eeMessageService(
    eventSigner: eventSigner,
    sealService: sealService,
    wrapService: wrapService,
    env: ref.watch(envProvider.notifier),
    fileCacheService: ref.watch(fileCacheServiceProvider),
    compressionService: ref.watch(compressServiceProvider),
    ionConnectNotifier: ref.watch(ionConnectNotifierProvider.notifier),
    ionConnectUploadNotifier: ref.watch(ionConnectUploadNotifierProvider.notifier),
    conversationPubkeysNotifier: ref.watch(conversationPubkeysProvider.notifier),
    currentUserMasterPubkey: ref.watch(currentPubkeySelectorProvider) ?? '',
    eventMessageDao: ref.watch(conversationEventMessageDaoProvider),
    mediaEncryptionService: ref.watch(mediaEncryptionServiceProvider),
    conversationMessageStatusDao: ref.watch(conversationMessageDataDaoProvider),
    conversationDao: ref.watch(conversationDaoProvider),
    sendChatMessageNotifier: ref.watch(sendChatMessageNotifierProvider.notifier),
  );
}

class SendE2eeMessageService {
  SendE2eeMessageService({
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.fileCacheService,
    required this.ionConnectNotifier,
    required this.compressionService,
    required this.ionConnectUploadNotifier,
    required this.conversationPubkeysNotifier,
    required this.mediaEncryptionService,
    required this.currentUserMasterPubkey,
    required this.eventMessageDao,
    required this.conversationMessageStatusDao,
    required this.conversationDao,
    required this.sendChatMessageNotifier,
  });

  final Env env;
  final EventSigner? eventSigner;
  final IonConnectNotifier ionConnectNotifier;
  final FileCacheService fileCacheService;
  final IonConnectSealService sealService;
  final IonConnectGiftWrapService wrapService;
  final CompressionService compressionService;
  final IonConnectUploadNotifier ionConnectUploadNotifier;
  final ConversationPubkeys conversationPubkeysNotifier;
  final MediaEncryptionService mediaEncryptionService;
  final String currentUserMasterPubkey;
  final ConversationDao conversationDao;
  final ConversationEventMessageDao eventMessageDao;
  final ConversationMessageDataDao conversationMessageStatusDao;
  final SendChatMessageNotifier sendChatMessageNotifier;
  Future<void> sendMessage({
    required String content,
    required String conversationId,
    required List<String> participantsMasterPubkeys,
    String? subject,
    List<String>? groupImageTag,
    List<MediaFile> mediaFiles = const [],
  }) async {
    await sendChatMessageNotifier.sendMessage(
      conversationId: conversationId,
      participantsMasterPubkeys: participantsMasterPubkeys,
      content: content,
      mediaFiles: mediaFiles,
    );
  }

  Future<void> resendFailedMessage(EventMessage failedMessageEvent) async {
    final entity = PrivateDirectMessageEntity.fromEventMessage(failedMessageEvent);

    final messageType = entity.data.messageType;

    final mediaUri = entity.data.media.values.map((media) => Uri.tryParse(media.url));

    final isMessageWithMedia = [
      MessageType.visualMedia,
      MessageType.audio,
      MessageType.document,
    ].contains(messageType);

    final isMediaUploaded =
        isMessageWithMedia && mediaUri.every((uri) => uri != null && uri.hasScheme);

    final isMediaNotUploaded =
        isMessageWithMedia && mediaUri.any((uri) => uri != null && !uri.hasScheme);

    final messageStatuses =
        await conversationMessageStatusDao.messageStatuses(failedMessageEvent.id);

    final failedParticipantsMasterPubkeysMap = messageStatuses
      ..removeWhere((key, value) => value != MessageDeliveryStatus.failed);

    final failedParticipantsMasterPubkeys = failedParticipantsMasterPubkeysMap.keys.toList();

    final participantsKeysMap =
        await conversationPubkeysNotifier.fetchUsersKeys(failedParticipantsMasterPubkeys);

    // If this is message without media or message with media but media was successfully uploaded
    if (!isMessageWithMedia || isMediaUploaded) {
      await Future.wait(
        failedParticipantsMasterPubkeys.map((masterPubkey) async {
          final pubkey = participantsKeysMap[masterPubkey];

          if (pubkey == null) {
            throw UserPubkeyNotFoundException(masterPubkey);
          }

          final giftWrap = await createGiftWrap(
            signer: eventSigner!,
            eventMessage: failedMessageEvent,
            receiverMasterPubkey: masterPubkey,
            receiverPubkey: failedMessageEvent.pubkey,
          );

          await ionConnectNotifier.sendEvent(
            giftWrap,
            cache: false,
            actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
          );

          await conversationMessageStatusDao.add(
            masterPubkey: masterPubkey,
            eventMessageId: failedMessageEvent.id,
            status: masterPubkey == currentUserMasterPubkey
                ? MessageDeliveryStatus.read
                : MessageDeliveryStatus.sent,
          );
        }),
      );
    } else if (isMediaNotUploaded) {
      // Try to find local path and upload media again
      final mediaFilesToUpload = entity.data.media.values
          .map(
            (media) => MediaFile(
              path: media.url,
              mimeType: media.mimeType,
            ),
          )
          .toList();

      final compressedMediaFiles = await compressMediaFiles(mediaFilesToUpload);

      await Future.wait(
        failedParticipantsMasterPubkeys.map((masterPubkey) async {
          final pubkey = participantsKeysMap[masterPubkey];

          if (pubkey == null) {
            throw UserPubkeyNotFoundException(masterPubkey);
          }

          final encryptedMediaFiles =
              await mediaEncryptionService.encryptMediaFiles(compressedMediaFiles);

          final uploadedMediaFilesWithKeys = await Future.wait(
            encryptedMediaFiles.map((encryptedMediaFile) async {
              final mediaFile = encryptedMediaFile.mediaFile;
              final secretKey = encryptedMediaFile.secretKey;
              final nonce = encryptedMediaFile.nonce;
              final mac = encryptedMediaFile.mac;

              final oneTimeEventSigner = await Ed25519KeyStore.generate();

              final uploadResult = await ionConnectUploadNotifier.upload(
                mediaFile,
                alt: FileAlt.message,
                customEventSigner: oneTimeEventSigner,
              );

              final fileMetadataEvent = await generateFileMetadataEvent(
                ontTimeEventSigner: oneTimeEventSigner,
                fileMetadataEntity: uploadResult.fileMetadata,
              );

              await ionConnectNotifier.sendEvent(
                fileMetadataEvent,
                cache: false,
                actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
              );

              return (uploadResult, secretKey, nonce, mac, null, null);
            }),
          );

          final imetaTags = generateImetaTags(uploadedMediaFilesWithKeys);

          final conversationTags = generateConversationTags(
            conversationId: entity.data.uuid,
            masterPubkeys: entity.allPubkeys,
          )..addAll(imetaTags);

          final eventMessageWithMedia = await createEventMessage(
            signer: eventSigner!,
            tags: conversationTags,
            previousId: failedMessageEvent.id,
            content: failedMessageEvent.content,
          );

          // We replace existing event message with the one with uploaded media
          if (masterPubkey == currentUserMasterPubkey) {
            await eventMessageDao.add(eventMessageWithMedia);
          }

          final giftWrap = await createGiftWrap(
            signer: eventSigner!,
            receiverPubkey: pubkey,
            receiverMasterPubkey: masterPubkey,
            eventMessage: eventMessageWithMedia,
          );

          await ionConnectNotifier.sendEvent(
            giftWrap,
            cache: false,
            actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
          );

          await conversationMessageStatusDao.add(
            masterPubkey: masterPubkey,
            eventMessageId: eventMessageWithMedia.id,
            status: masterPubkey == currentUserMasterPubkey
                ? MessageDeliveryStatus.read
                : MessageDeliveryStatus.sent,
          );
        }),
      );
    }
  }

  Future<EventMessage> generateFileMetadataEvent({
    required Ed25519KeyStore ontTimeEventSigner,
    required EventSerializable fileMetadataEntity,
  }) async {
    final expirationTag = EntityExpiration(
      value:
          DateTime.now().add(Duration(hours: env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS))),
    ).toTag();

    return fileMetadataEntity.toEventMessage(
      ontTimeEventSigner,
      tags: [expirationTag],
    );
  }

  final allowedStatus = [MessageDeliveryStatus.received, MessageDeliveryStatus.read];

  Future<void> sendMessageStatus(
    EventMessage kind14Rumor,
    MessageDeliveryStatus status,
  ) async {
    if (!allowedStatus.contains(status)) {
      return;
    }

    final eventMessage = await createEventMessage(
      content: status.name,
      signer: eventSigner!,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        [PubkeyTag.tagName, kind14Rumor.pubkey],
        [RelatedImmutableEvent.tagName, kind14Rumor.id],
        ['b', currentUserMasterPubkey],
      ],
    );

    final privateDirectMessageEntity = PrivateDirectMessageData.fromEventMessage(kind14Rumor);

    final participantsMasterPubkeys =
        privateDirectMessageEntity.relatedPubkeys?.map((tag) => tag.value).toList();

    if (participantsMasterPubkeys == null) {
      throw ParticipantsMasterPubkeysNotFoundException(kind14Rumor.id);
    }

    await Future.wait(
      participantsMasterPubkeys.map((masterPubkey) async {
        final currentUser = currentUserMasterPubkey == masterPubkey;

        final participantsKeysMap =
            await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);
        final pubkey = participantsKeysMap[masterPubkey];

        if (pubkey == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        final giftWrap = await createGiftWrap(
          signer: eventSigner!,
          eventMessage: eventMessage,
          receiverMasterPubkey: masterPubkey,
          kind: PrivateMessageReactionEntity.kind,
          receiverPubkey: currentUser ? eventSigner!.publicKey : pubkey,
        );

        await ionConnectNotifier.sendEvent(
          giftWrap,
          cache: false,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
        );
      }),
    );
  }

  Future<void> sendReaction({
    required String content,
    required EventMessage kind14Rumor,
  }) async {
    final eventMessage = await createEventMessage(
      content: content,
      signer: eventSigner!,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        [PubkeyTag.tagName, kind14Rumor.pubkey],
        [RelatedImmutableEvent.tagName, kind14Rumor.id],
        ['b', currentUserMasterPubkey],
      ],
    );

    final privateDirectMessageEntity = PrivateDirectMessageData.fromEventMessage(kind14Rumor);

    final participantsMasterPubkeys =
        privateDirectMessageEntity.relatedPubkeys?.map((tag) => tag.value).toList();

    if (participantsMasterPubkeys == null) {
      throw ParticipantsMasterPubkeysNotFoundException(kind14Rumor.id);
    }

    await Future.wait(
      participantsMasterPubkeys.map((masterPubkey) async {
        final currentUser = currentUserMasterPubkey == masterPubkey;

        final participantsKeysMap =
            await conversationPubkeysNotifier.fetchUsersKeys(participantsMasterPubkeys);
        final pubkey = participantsKeysMap[masterPubkey];

        if (pubkey == null) {
          throw UserPubkeyNotFoundException(masterPubkey);
        }

        final giftWrap = await createGiftWrap(
          signer: eventSigner!,
          eventMessage: eventMessage,
          receiverMasterPubkey: masterPubkey,
          kind: PrivateMessageReactionEntity.kind,
          receiverPubkey: currentUser ? eventSigner!.publicKey : pubkey,
        );

        await ionConnectNotifier.sendEvent(
          giftWrap,
          cache: false,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
        );
      }),
    );
  }

  Future<void> sendKind14Message({
    required String pubkey,
    required String content,
    required String masterPubkey,
    required List<List<String>> conversationTags,
  }) async {
    final eventMessage = await createEventMessage(
      content: content,
      signer: eventSigner!,
      tags: conversationTags,
    );

    try {
      final giftWrap = await createGiftWrap(
        signer: eventSigner!,
        receiverPubkey: pubkey,
        eventMessage: eventMessage,
        receiverMasterPubkey: masterPubkey,
      );

      if (masterPubkey == currentUserMasterPubkey) {
        await conversationDao.add([eventMessage]);
        await eventMessageDao.add(eventMessage);
      }

      await conversationMessageStatusDao.add(
        masterPubkey: masterPubkey,
        eventMessageId: eventMessage.id,
        status: MessageDeliveryStatus.created,
      );

      await ionConnectNotifier.sendEvent(
        giftWrap,
        cache: false,
        actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
      );

      await conversationMessageStatusDao.add(
        masterPubkey: masterPubkey,
        eventMessageId: eventMessage.id,
        status: masterPubkey == currentUserMasterPubkey
            ? MessageDeliveryStatus.read
            : MessageDeliveryStatus.sent,
      );
    } catch (e) {
      await conversationMessageStatusDao.add(
        masterPubkey: masterPubkey,
        eventMessageId: eventMessage.id,
        status: MessageDeliveryStatus.failed,
      );
    }
  }

  List<List<String>> generateConversationTags({
    required String conversationId,
    required List<String> masterPubkeys,
    String? subject,
    List<String>? groupImageTag,
  }) {
    final tags = [
      if (subject != null) ['subject', subject],
      ...masterPubkeys.map((pubkey) => ['p', pubkey]),
      [CommunityIdentifierTag.tagName, conversationId],
      if (groupImageTag != null) groupImageTag,
      ['b', currentUserMasterPubkey],
    ];

    return tags;
  }

  Future<EventMessage> createEventMessage({
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

  Future<EventMessage> createGiftWrap({
    required String receiverPubkey,
    required String receiverMasterPubkey,
    required EventSigner signer,
    required EventMessage eventMessage,
    int kind = PrivateDirectMessageEntity.kind,
  }) async {
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

  Future<List<MediaFile>> compressMediaFiles(
    List<MediaFile> mediaFiles,
  ) async {
    // Would be better to compress all media files in isolates when this one is
    // fixed https://github.com/arthenica/ffmpeg-kit/issues/367
    final compressedMediaFiles = await Future.wait(
      mediaFiles.map(
        (mediaFile) async {
          final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

          final compressedMediaFile = switch (mediaType) {
            MediaType.video =>
              await compressionService.compressVideo(mediaFile, generateThumbnail: true),
            MediaType.image => await compressionService.compressImage(
                mediaFile,
                width: mediaFile.width,
                height: mediaFile.height,
              ),
            MediaType.audio => await compressionService.compressAudio(mediaFile.path),
            MediaType.unknown => await compressionService.compressWithBrotli(File(mediaFile.path)),
          };

          return compressedMediaFile;
        },
      ).toList(),
    );

    return compressedMediaFiles;
  }

  List<List<String>> generateImetaTags(
    List<(UploadResult, String, String, String, String?, String?)> uploadResults,
  ) {
    final expiration = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS)),
      ),
    );

    return uploadResults.map((uploadResult) {
      final fileMetadata = uploadResult.$1.fileMetadata;

      final secretKey = uploadResult.$2;
      final nonce = uploadResult.$3;
      final mac = uploadResult.$4;
      final thumbUrl = uploadResult.$5;
      final blurhash = uploadResult.$6;
      return [
        'imeta',
        'url ${fileMetadata.url}',
        'alt ${fileMetadata.alt}',
        'm ${fileMetadata.mimeType}',
        'dim ${fileMetadata.dimension}',
        'x ${fileMetadata.fileHash}',
        'ox ${fileMetadata.originalFileHash}',
        'expiration ${expiration.value.millisecondsSinceEpoch ~/ 1000}',
        'encryption-key $secretKey $nonce $mac aes-gcm',
        if (thumbUrl != null) 'thumb $thumbUrl',
        if (blurhash != null) 'blurhash $blurhash',
      ];
    }).toList();
  }
}
