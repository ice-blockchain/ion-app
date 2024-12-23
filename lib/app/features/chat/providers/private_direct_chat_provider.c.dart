// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/entities/private_message_reaction_data.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/nostr/model/entity_expiration.c.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_event_signer_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_seal_service.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'private_direct_chat_provider.c.g.dart';

@riverpod
class PrivateDirectChatProvider extends _$PrivateDirectChatProvider {
  @override
  void build() {}

  Future<List<NostrEntity?>> sentMessage({
    required String content,
    required List<String> participantsPubkeys,
    String? subject,
    List<MediaFile> mediaFiles = const [],
  }) async {
    final sealService = IonConnectSealServiceImpl();
    final wrapService = IonConnectGiftWrapServiceImpl();
    final currentUserSigner = await ref.read(currentUserNostrEventSignerProvider.future);

    if (currentUserSigner == null) {
      throw EventSignerNotFoundException();
    }

    final conversationTags = _generateConversationTags(
      subject: subject,
      pubkeys: participantsPubkeys,
    );

    if (mediaFiles.isNotEmpty) {
      final compressedMediaFiles = await _compressMediaFiles(mediaFiles);

      final results = await Future.wait(
        participantsPubkeys.map((participantPubkey) async {
          final encryptedMediaFiles = await _encryptMediaFiles(compressedMediaFiles);

          final uploadedMediaFilesWithKeys = await Future.wait(
            encryptedMediaFiles.map((encryptedMediaFile) async {
              final mediaFile = encryptedMediaFile.$1;
              final secretBox = encryptedMediaFile.$2;
              final secretKeyBytes = encryptedMediaFile.$3;

              final uploadResult = await ref
                  .read(nostrUploadNotifierProvider.notifier)
                  .upload(mediaFile, alt: FileAlt.message);

              log('Uploaded media file: ${uploadResult.fileMetadata.url}, ${uploadResult.fileMetadata.mimeType} ${uploadResult.fileMetadata.size}');

              return (uploadResult, secretBox, secretKeyBytes);
            }),
          );

          final imetaTags = _generateImetaTags(uploadedMediaFilesWithKeys);

          log('Generated meta tags: $imetaTags');

          final tags = conversationTags..addAll(imetaTags);

          return _createSealWrapSendMessage(
            tags: tags,
            content: content,
            sealService: sealService,
            wrapService: wrapService,
            signer: currentUserSigner,
            receiverPubkey: participantPubkey,
          );
        }),
      );

      return results;
    } else {
      // Send copy of the message to each participant
      final results = await Future.wait(
        participantsPubkeys.map((participantPubkey) async {
          return _createSealWrapSendMessage(
            content: content,
            tags: conversationTags,
            sealService: sealService,
            wrapService: wrapService,
            signer: currentUserSigner,
            receiverPubkey: participantPubkey,
          );
        }).toList(),
      );

      return results;
    }
  }

  Future<void> sendMessageReceivedStatus({
    required String eventId,
    required String receiverPubkey,
  }) async {
    final currentUserSigner = await ref.read(currentUserNostrEventSignerProvider.future);

    if (currentUserSigner == null) {
      throw EventSignerNotFoundException();
    }

    final sealService = IonConnectSealServiceImpl();
    final wrapService = IonConnectGiftWrapServiceImpl();

    await _createSealWrapSendMessage(
      signer: currentUserSigner,
      content: 'received',
      receiverPubkey: receiverPubkey,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        ['p', receiverPubkey],
        ['e', eventId],
      ],
      sealService: sealService,
      wrapService: wrapService,
    );
  }

  // Works in progress with https://pub.dev/packages/flutter_cache_manager
  Future<MediaFile> downloadDecryptDecompressMedia() {
    throw UnimplementedError();
  }

  List<List<String>> _generateConversationTags({
    required List<String> pubkeys,
    String? subject,
  }) {
    final tags = [
      if (subject != null && pubkeys.length > 1) ['subject', subject],
      ...pubkeys.map((pubkey) => ['p', pubkey]),
    ];

    return tags;
  }

  Future<NostrEntity?> _createSealWrapSendMessage({
    required String content,
    required String receiverPubkey,
    required EventSigner signer,
    required List<List<String>> tags,
    required IonConnectSealService sealService,
    required IonConnectGiftWrapService wrapService,
    int? kind,
  }) async {
    final nostrNotifier = ref.read(nostrNotifierProvider.notifier);

    final createdAt = DateTime.now().toUtc();

    final id = EventMessage.calculateEventId(
      publicKey: signer.publicKey,
      createdAt: createdAt,
      kind: kind ?? PrivateDirectMessageEntity.kind,
      tags: tags,
      content: content,
    );

    final eventMessage = EventMessage(
      id: id,
      tags: tags,
      content: content,
      createdAt: createdAt,
      pubkey: signer.publicKey,
      kind: kind ?? PrivateDirectMessageEntity.kind,
      sig: null,
    );

    log('Event message $eventMessage');

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    log('Seal message $seal');

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(
          hours: ref.read(envProvider.notifier).get<int>(EnvVariable.STORY_EXPIRATION_HOURS),
        ),
      ),
    ).toTag();

    final wrap = await wrapService.createWrap(
      seal,
      receiverPubkey,
      signer,
      kind ?? PrivateDirectMessageEntity.kind,
      expirationTag: kind == PrivateDirectMessageEntity.kind ? expirationTag : null,
    );

    log('Wrap message $wrap');

    final result = await nostrNotifier.sendEvent(wrap, cache: false);

    log('Sent message $result');

    return result;
  }

  Future<List<MediaFile>> _compressMediaFiles(
    List<MediaFile> mediaFiles,
  ) async {
    final compressService = ref.read(compressServiceProvider);

    // Would be better to compress all media files in isolates when this one is
    // fixed https://github.com/arthenica/ffmpeg-kit/issues/367
    final compressedMediaFiles = await Future.wait(
      mediaFiles.map(
        (mediaFile) async {
          final size = File(mediaFile.path).lengthSync();
          log('Original media file: ${mediaFile.path}, ${mediaFile.mimeType} $size');

          final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

          final compressedMediaFile = switch (mediaType) {
            MediaType.video => await compressService.compressVideo(mediaFile),
            MediaType.image => await compressService.compressImage(
                mediaFile,
                width: mediaFile.width,
                height: mediaFile.height,
              ),
            MediaType.audio => MediaFile(
                width: 0,
                height: 0,
                mimeType: mediaFile.mimeType,
                path: await compressService.compressAudio(mediaFile.path),
              ),
            MediaType.unknown => MediaFile(
                path: (await compressService.compressWithBrotli(File(mediaFile.path))).path,
              )
          };

          final compressedSize = File(compressedMediaFile.path).lengthSync();
          log('Compressed media file: ${compressedMediaFile.path}, ${compressedMediaFile.mimeType} $compressedSize');

          return compressedMediaFile;
        },
      ).toList(),
    );

    return compressedMediaFiles;
  }

  Future<List<(MediaFile, String, String)>> _encryptMediaFiles(
    List<MediaFile> compressedMediaFiles,
  ) async {
    final encryptedMediaFilesWithSecretBox = await Future.wait(
      compressedMediaFiles.map(
        (compressedMediaFile) => Isolate.run<(MediaFile, String, String)>(() async {
          final secretKey = await AesGcm.with256bits().newSecretKey();
          final secretKeyBytes = await secretKey.extractBytes();
          final secretKeyString = base64Encode(secretKeyBytes);

          final compressedMediaFileBytes = await File(compressedMediaFile.path).readAsBytes();

          final secretBox = await AesGcm.with256bits().encrypt(
            compressedMediaFileBytes,
            secretKey: secretKey,
          );

          final nonceBytes = secretBox.nonce;
          final nonceString = base64Encode(nonceBytes);

          final compressedEncryptedFile = File('${compressedMediaFile.path}.enc');
          // Rewrite compressed fieles with encrypted data
          await compressedEncryptedFile.writeAsBytes(secretBox.cipherText);

          final compressedEncryptedMediaFile = MediaFile(
            path: compressedEncryptedFile.path,
            width: compressedMediaFile.width,
            height: compressedMediaFile.height,
            mimeType: compressedMediaFile.mimeType,
          );

          log('Encrypted media file ${compressedEncryptedMediaFile.mimeType} ${compressedEncryptedFile.lengthSync()}');

          return (compressedEncryptedMediaFile, nonceString, secretKeyString);
        }),
      ),
    );

    return encryptedMediaFilesWithSecretBox;
  }

  List<List<String>> _generateImetaTags(
    List<(UploadResult, String, String)> uploadResults,
  ) {
    final expiration = EntityExpiration(
      value: DateTime.now().add(
        Duration(
          hours: ref.read(envProvider.notifier).get<int>(EnvVariable.STORY_EXPIRATION_HOURS),
        ),
      ),
    );

    return uploadResults.map((uploadResult) {
      final fileMetadata = uploadResult.$1.fileMetadata;

      final nonce = uploadResult.$2;
      final secretKey = uploadResult.$3;

      return [
        'imeta',
        'url ${fileMetadata.url}',
        'alt ${fileMetadata.alt}',
        'm ${fileMetadata.mimeType}',
        'dim ${fileMetadata.dimension}',
        'x ${fileMetadata.fileHash}',
        'ox ${fileMetadata.originalFileHash}',
        'expiration ${expiration.value.millisecondsSinceEpoch ~/ 1000}',
        'encryption-key $secretKey $nonce aes-gcm',
      ];
    }).toList();
  }
}

// Example usage:
/*
  final privateDirectChatProvider = ref.read(privateDirectChatProviderProvider.notifier);

  final selectedFiles = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'],
  );

  await privateDirectChatProvider.sentMessage(
    subject: 'Test group',
    content: 'Hello',
    mediaFiles: [
      MediaFile(
        path: selectedFiles?.files.single.path ?? '',
        mimeType: 'image/jpeg',
      ),
    ],
    participantsPubkeys: [
      'c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377',
    ],
  );

  await privateDirectChatProvider.sendMessageReceivedStatus(
    eventId: 'd44ac1ef3ed47b9dd01be2df8ad2f24b50706164004ff71ddf2d0bcfe9ea9857',
    receiverPubkey:
        'c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377',
  );

*/
