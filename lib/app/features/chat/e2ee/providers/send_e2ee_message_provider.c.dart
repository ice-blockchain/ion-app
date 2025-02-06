// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:cryptography/cryptography.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_pubkeys_provider.c.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_gift_wrap_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_seal_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_e2ee_message_provider.c.g.dart';

@riverpod
class SendE2eeMessageNotifier extends _$SendE2eeMessageNotifier {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> send({
    required String conversationUUID,
    required String message,
    required List<String> participantMasterPubkeys,
    required String? subject,
    List<MediaFile>? mediaFiles,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final currentUserPubkey = ref.read(currentPubkeySelectorProvider).valueOrNull;

      if (currentUserPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final conversationTags = _generateConversationTags(
        subject: subject,
        conversationUuid: conversationUUID,
        masterPubkeys: [...participantMasterPubkeys, currentUserPubkey],
      );

      final participantsKeysMap = await ref
          .read(conversationPubkeysProvider.notifier)
          .fetchUsersKeys(participantMasterPubkeys);

      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        final compressedMediaFiles = await _compressMediaFiles(mediaFiles);

        await Future.wait(
          participantMasterPubkeys.map((masterPubkey) async {
            final pubkey = participantsKeysMap[masterPubkey];

            if (pubkey == null) {
              throw UserPubkeyNotFoundException(masterPubkey);
            }

            final encryptedMediaFiles = await _encryptMediaFiles(compressedMediaFiles);

            final uploadedMediaFilesWithKeys = await Future.wait(
              encryptedMediaFiles.map((encryptedMediaFile) async {
                final mediaFile = encryptedMediaFile.$1;
                final secretKey = encryptedMediaFile.$2;
                final nonce = encryptedMediaFile.$3;
                final mac = encryptedMediaFile.$4;

                final uploadResult =
                    await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
                          mediaFile,
                          alt: FileAlt.message,
                        );

                return (uploadResult, secretKey, nonce, mac);
              }),
            );

            for (final mediaFile in encryptedMediaFiles) {
              final file = File(mediaFile.$1.path);
              await file.delete();
            }

            final imetaTags = _generateImetaTags(uploadedMediaFilesWithKeys);

            final tags = conversationTags..addAll(imetaTags);

            final giftWrap = await _createGiftWrap(
              tags: tags,
              content: message,
              signer: eventSigner,
              receiverPubkey: pubkey,
              receiverMasterkey: masterPubkey,
            );

            return _sendGiftWrap(giftWrap, masterPubkey: masterPubkey);
          }),
        );

        for (final mediaFile in compressedMediaFiles) {
          final file = File(mediaFile.path);
          await file.delete();
        }
      } else {
        await Future.wait(
          participantMasterPubkeys.map((masterPubkey) async {
            final pubkey = participantsKeysMap[masterPubkey];

            if (pubkey == null) {
              throw UserPubkeyNotFoundException(masterPubkey);
            }

            final giftWrap = await _createGiftWrap(
              content: message,
              signer: eventSigner,
              tags: conversationTags,
              receiverPubkey: pubkey,
              receiverMasterkey: masterPubkey,
            );

            return _sendGiftWrap(giftWrap, masterPubkey: masterPubkey);
          }).toList(),
        );
      }
    });
  }

  Future<List<MediaFile>> _compressMediaFiles(
    List<MediaFile> mediaFiles,
  ) async {
    // Would be better to compress all media files in isolates when this one is
    // fixed https://github.com/arthenica/ffmpeg-kit/issues/367

    final compressionService = ref.read(compressServiceProvider);
    final compressedMediaFiles = await Future.wait(
      mediaFiles.map(
        (mediaFile) async {
          final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

          final compressedMediaFile = switch (mediaType) {
            MediaType.video => await compressionService.compressVideo(mediaFile),
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
                path: (await compressionService.compressWithBrotli(File(mediaFile.path))).path,
              )
          };

          return compressedMediaFile;
        },
      ).toList(),
    );

    return compressedMediaFiles;
  }

  List<List<String>> _generateConversationTags({
    required String conversationUuid,
    required List<String> masterPubkeys,
    required String? subject,
  }) {
    return [
      if (subject != null && masterPubkeys.length > 1) ['subject', subject],
      ...masterPubkeys.map((pubkey) => ['p', pubkey]),
      CommunityIdentifierTag(value: conversationUuid).toTag(),
    ];
  }

  Future<List<(MediaFile, String, String, String)>> _encryptMediaFiles(
    List<MediaFile> compressedMediaFiles,
  ) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final encryptedMediaFiles = await Future.wait(
      compressedMediaFiles.map(
        (compressedMediaFile) => Isolate.run<(MediaFile, String, String, String)>(() async {
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
          final macString = base64Encode(secretBox.mac.bytes);

          final compressedEncryptedFile =
              File('${documentsDir.path}/${compressedMediaFileBytes.hashCode}.enc');

          await compressedEncryptedFile.writeAsBytes(secretBox.cipherText);

          final compressedEncryptedMediaFile = MediaFile(
            path: compressedEncryptedFile.path,
            width: compressedMediaFile.width,
            height: compressedMediaFile.height,
            mimeType: compressedMediaFile.mimeType,
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
    final env = ref.read(envProvider.notifier);
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

  Future<EventMessage> _createGiftWrap({
    required String content,
    required String receiverPubkey,
    required String receiverMasterkey,
    required EventSigner signer,
    required List<List<String>> tags,
  }) async {
    final env = ref.read(envProvider.notifier);
    final sealService = await ref.read(ionConnectSealServiceProvider.future);
    final wrapService = await ref.read(ionConnectGiftWrapServiceProvider.future);
    final createdAt = DateTime.now().toUtc();

    final id = EventMessage.calculateEventId(
      tags: tags,
      content: content,
      createdAt: createdAt,
      publicKey: signer.publicKey,
      kind: PrivateDirectMessageEntity.kind,
    );

    final eventMessage = EventMessage(
      id: id,
      tags: tags,
      content: content,
      createdAt: createdAt,
      pubkey: signer.publicKey,
      kind: PrivateDirectMessageEntity.kind,
      sig: null,
    );

    final expirationTag = EntityExpiration(
      value: DateTime.now().add(
        // TODO:  Create GIFT_WRAP_EXPIRATION_TIME env variable
        Duration(hours: env.get<int>(EnvVariable.STORY_EXPIRATION_HOURS)),
      ),
    ).toTag();

    final seal = await sealService.createSeal(
      eventMessage,
      signer,
      receiverPubkey,
    );

    final wrap = await wrapService.createWrap(
      event: seal,
      receiverPubkey: receiverPubkey,
      receiverMasterkey: receiverMasterkey,
      contentKind: PrivateDirectMessageEntity.kind,
      expirationTag: expirationTag,
    );

    return wrap;
  }

  Future<IonConnectEntity?> _sendGiftWrap(
    EventMessage giftWrap, {
    required String masterPubkey,
  }) async {
    return ref.read(ionConnectNotifierProvider.notifier).sendEvent(
          giftWrap,
          cache: false,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
        );
  }
}
