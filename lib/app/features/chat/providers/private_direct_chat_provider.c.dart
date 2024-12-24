// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import 'package:ion/app/services/file_cache/ion_file_cache_manager.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/nostr/ion_connect_seal_service.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'private_direct_chat_provider.c.g.dart';

// Example usage:
/*
  final privateDirectChatProvider =
      ref.watch(privateDirectChatServiceProvider).requireValue;

  Future.delayed(const Duration(seconds: 15), () {
    privateDirectChatProvider.downloadDecryptDecompressMedia(
      PrivateDirectMessageEntity.fromEventMessage(
        EventMessage(
          id: '0400b82dd7d0ab96e93e0688a6cb49ce0062ed30d1556118089a579b8c9ae783',
          pubkey:
              '6bd14684b3ed3632d913e6c52c8c64df4fa46871e7cebd08bd745432924b565b',
          content: 'Hello',
          createdAt: DateTime.now(),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            [
              'imeta',
              'url https://bom1-1.staging.ion-connect.ice.vip:4443/files/127fe9ddceb9cf5240bacf6c40c484aab4fe65255beefefbc82303e643486e3c:6af38a5a65ab8b7fba53e659023e07f727d5ee0d9ffaf81dfbec2a3e80c6b802.enc',
              'alt message',
              'm image/webp',
              'dim null',
              'x 6af38a5a65ab8b7fba53e659023e07f727d5ee0d9ffaf81dfbec2a3e80c6b802',
              'ox 6af38a5a65ab8b7fba53e659023e07f727d5ee0d9ffaf81dfbec2a3e80c6b802',
              'expiration 1735043248',
              'encryption-key vSn0v3V1UyxBfehQ1m/fR0b/LsbzlM60/+Rbwr6BOKE= jzMoGrgE/eYplHcZ nkd3OhZcCx7+bSb/B0nbAg== aes-gcm',
            ]
          ],
          sig:
              'eddsa/curve25519:2847691e54e2c619960aa4bf125d66f2d531f503d6681ffe39a7495b360e4aba63c04c9085a7cd6627628833b8f1c2a1df98f20b1ca06db43246bce05766e20c',
        ),
      ),
    );
  });

  
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

@Riverpod(keepAlive: true)
Future<PrivateDirectChatService> privateDirectChatService(Ref ref) async {
  final eventSigner =
      await ref.watch(currentUserNostrEventSignerProvider.future);

  return PrivateDirectChatService(
    eventSigner: eventSigner,
    env: ref.watch(envProvider.notifier),
    fileCacheService: ref.watch(fileCacheServiceProvider),
    sealService: ref.watch(ionConnectSealServiceProvider),
    compressionService: ref.watch(compressServiceProvider),
    nostrNotifier: ref.watch(nostrNotifierProvider.notifier),
    wrapService: ref.watch(ionConnectGiftWrapServiceProvider),
    nostrUploadNotifier: ref.watch(nostrUploadNotifierProvider.notifier),
  );
}

class PrivateDirectChatService {
  PrivateDirectChatService({
    required this.env,
    required this.wrapService,
    required this.sealService,
    required this.eventSigner,
    required this.nostrNotifier,
    required this.fileCacheService,
    required this.nostrUploadNotifier,
    required this.compressionService,
  });

  final Env env;
  final EventSigner? eventSigner;
  final NostrNotifier nostrNotifier;
  final FileCacheService fileCacheService;
  final IonConnectSealService sealService;
  final IonConnectGiftWrapService wrapService;
  final CompressionService compressionService;
  final NostrUploadNotifier nostrUploadNotifier;

  Future<List<NostrEntity?>> sentMessage({
    required String content,
    required List<String> participantsPubkeys,
    String? subject,
    List<MediaFile> mediaFiles = const [],
  }) async {
    if (eventSigner == null) {
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
          final encryptedMediaFiles =
              await _encryptMediaFiles(compressedMediaFiles);

          final uploadedMediaFilesWithKeys = await Future.wait(
            encryptedMediaFiles.map((encryptedMediaFile) async {
              final mediaFile = encryptedMediaFile.$1;
              final secretKey = encryptedMediaFile.$2;
              final nonce = encryptedMediaFile.$3;
              final mac = encryptedMediaFile.$4;

              final uploadResult = await nostrUploadNotifier.upload(
                mediaFile,
                alt: FileAlt.message,
              );

              Logger.log(
                'Uploaded media file: ${uploadResult.fileMetadata.url}, ${uploadResult.fileMetadata.mimeType} ${uploadResult.fileMetadata.size}',
              );

              return (uploadResult, secretKey, nonce, mac);
            }),
          );

          final imetaTags = _generateImetaTags(uploadedMediaFilesWithKeys);

          final tags = conversationTags..addAll(imetaTags);

          return _createSealWrapSendMessage(
            tags: tags,
            content: content,
            signer: eventSigner!,
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
            signer: eventSigner!,
            tags: conversationTags,
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
    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    await _createSealWrapSendMessage(
      signer: eventSigner!,
      content: 'received',
      receiverPubkey: receiverPubkey,
      kind: PrivateMessageReactionEntity.kind,
      tags: [
        ['k', PrivateDirectMessageEntity.kind.toString()],
        ['p', receiverPubkey],
        ['e', eventId],
      ],
    );
  }

  // Works in progress with https://pub.dev/packages/flutter_cache_manager
  Future<List<File>> downloadDecryptDecompressMedia(
    PrivateDirectMessageEntity privateDirectMessageEntity,
  ) async {
    final decryptedDecompressedFiles = <File>[];

    for (final attachment in privateDirectMessageEntity.data.media.values) {
      Logger.log('Attachment: $attachment');
      if (attachment.encryptionKey != null &&
          attachment.encryptionNonce != null &&
          attachment.encryptionMac != null) {
        final mac = base64Decode(attachment.encryptionMac!);
        final nonce = base64Decode(attachment.encryptionNonce!);
        final secretKey = base64Decode(attachment.encryptionKey!);

        final file = await fileCacheService.getFile(attachment.url);

        Logger.log(
          'Downloaded encrypted media file: ${file.path}, ${attachment.mimeType} ${file.lengthSync()}',
        );

        final fileBytes = await file.readAsBytes();

        final secretBox = SecretBox(
          fileBytes,
          nonce: nonce,
          mac: Mac(mac),
        );

        // Wrong Mac authentication error described here
        // https://github.com/dint-dev/cryptography/issues/147
        final decryptedFileBytesList = await AesGcm.with256bits().decrypt(
          secretBox,
          secretKey: SecretKey(secretKey),
        );

        final decryptedFileBytes = Uint8List.fromList(decryptedFileBytesList);

        final decryptedFile = await fileCacheService.putFile(
          url: file.path,
          bytes: decryptedFileBytes,
          fileExtension: attachment.mimeType.split('/').last,
        );

        Logger.log(
          'Decrypted media file: ${decryptedFile.path}, ${attachment.mimeType} ${decryptedFile.lengthSync()}',
        );

        if (attachment.mediaType == MediaType.unknown) {
          final decompressedFile =
              await compressionService.decompressBrotli(file);

          decryptedDecompressedFiles.add(decompressedFile);
        } else {
          decryptedDecompressedFiles.add(decryptedFile);
        }
      }
    }
    return decryptedDecompressedFiles;
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
    int? kind,
  }) async {
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

    Logger.log('Event message $eventMessage');

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    Logger.log('Seal message $seal');

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        Duration(
          hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS),
        ),
      ),
    ).toTag();

    final wrap = await wrapService.createWrap(
      seal,
      receiverPubkey,
      signer,
      kind ?? PrivateDirectMessageEntity.kind,
      expirationTag:
          kind == PrivateDirectMessageEntity.kind ? expirationTag : null,
    );

    Logger.log('Wrap message $wrap');

    final result = await nostrNotifier.sendEvent(wrap, cache: false);

    Logger.log('Sent message $result');

    return result;
  }

  Future<List<MediaFile>> _compressMediaFiles(
    List<MediaFile> mediaFiles,
  ) async {
    // Would be better to compress all media files in isolates when this one is
    // fixed https://github.com/arthenica/ffmpeg-kit/issues/367
    final compressedMediaFiles = await Future.wait(
      mediaFiles.map(
        (mediaFile) async {
          final size = File(mediaFile.path).lengthSync();
          Logger.log(
            'Original media file: ${mediaFile.path}, ${mediaFile.mimeType} $size',
          );

          final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

          final compressedMediaFile = switch (mediaType) {
            MediaType.video =>
              await compressionService.compressVideo(mediaFile),
            MediaType.image => await compressionService.compressImage(
                mediaFile,
                width: mediaFile.width,
                height: mediaFile.height,
              ),
            MediaType.audio => MediaFile(
                width: 0,
                height: 0,
                mimeType: mediaFile.mimeType,
                path: await compressionService.compressAudio(mediaFile.path),
              ),
            MediaType.unknown => MediaFile(
                path: (await compressionService
                        .compressWithBrotli(File(mediaFile.path)))
                    .path,
              )
          };

          final compressedSize = File(compressedMediaFile.path).lengthSync();
          Logger.log(
            'Compressed media file: ${compressedMediaFile.path}, ${compressedMediaFile.mimeType} $compressedSize',
          );

          return compressedMediaFile;
        },
      ).toList(),
    );

    return compressedMediaFiles;
  }

  Future<List<(MediaFile, String, String, String)>> _encryptMediaFiles(
    List<MediaFile> compressedMediaFiles,
  ) async {
    final encryptedMediaFiles = await Future.wait(
      compressedMediaFiles.map(
        (compressedMediaFile) =>
            Isolate.run<(MediaFile, String, String, String)>(() async {
          final secretKey = await AesGcm.with256bits().newSecretKey();
          final secretKeyBytes = await secretKey.extractBytes();
          final secretKeyString = base64Encode(secretKeyBytes);

          final compressedMediaFileBytes =
              await File(compressedMediaFile.path).readAsBytes();

          final secretBox = await AesGcm.with256bits().encrypt(
            compressedMediaFileBytes,
            secretKey: secretKey,
          );

          final nonceBytes = secretBox.nonce;
          final nonceString = base64Encode(nonceBytes);
          final macString = base64Encode(secretBox.mac.bytes);

          final compressedEncryptedFile =
              File('${compressedMediaFile.path}.enc');
          // Rewrite compressed fieles with encrypted data
          await compressedEncryptedFile.writeAsBytes(secretBox.cipherText);

          final compressedEncryptedMediaFile = MediaFile(
            path: compressedEncryptedFile.path,
            width: compressedMediaFile.width,
            height: compressedMediaFile.height,
            mimeType: compressedMediaFile.mimeType,
          );

          Logger.log(
            'Encrypted media file ${compressedEncryptedMediaFile.mimeType} ${compressedEncryptedFile.lengthSync()}',
          );

          return (
            compressedEncryptedMediaFile,
            secretKeyString,
            nonceString,
            macString,
          );
        }),
      ),
    );

    return encryptedMediaFiles;
  }

  List<List<String>> _generateImetaTags(
    List<(UploadResult, String, String, String)> uploadResults,
  ) {
    final expiration = EntityExpiration(
      value: DateTime.now().add(
        Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
      ),
    );

    return uploadResults.map((uploadResult) {
      final fileMetadata = uploadResult.$1.fileMetadata;

      final secretKey = uploadResult.$2;
      final nonce = uploadResult.$3;
      final mac = uploadResult.$4;

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
      ];
    }).toList();
  }
}
