import 'dart:convert';
import 'dart:io';

import 'package:blurhash_ffi/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/compress_media_provider.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/ion_connect/ed25519_key_store.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_chat_media_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SendChatMedia extends _$SendChatMedia {
  @override
  Future<List<MediaAttachment>> build(
    MediaFile mediaFile,
  ) async {
    return [];
  }

  Future<List<(String, MediaAttachment)>> sendChatMedia(
    List<String> participantsMasterPubkeys,
  ) async {
    final mediaAttachments = <MediaAttachment>[];
    final result = <(String, MediaAttachment)>[];

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        final blurHash = await _getBlurhash(mediaFile);

        final compressedMediaFile = (await ref.read(compressMediaFileProvider(mediaFile).future))
            .copyWith(blurhash: blurHash);

        for (final participantMasterPubkey in participantsMasterPubkeys) {
          final mediaAttachment = await processMedia(compressedMediaFile, participantMasterPubkey);
          mediaAttachments.add(mediaAttachment);
          result.add((participantMasterPubkey, mediaAttachment));
        }

        return mediaAttachments;
      },
    );

    return result;
  }

  Future<String?> _getBlurhash(MediaFile mediaFile) async {
    final isImage = mediaFile.mimeType?.startsWith('image/') ?? false;
    if (isImage) {
      final image = FileImage(File(mediaFile.path));
      final blurhash = await BlurhashFFI.encode(image);
      return blurhash;
    }
    return null;
  }

  Future<MediaAttachment> processMedia(
    MediaFile mediaFile,
    String masterPubkey,
  ) async {
    final oneTimeEventSigner = await Ed25519KeyStore.generate();
    final env = ref.read(envProvider.notifier);

    final isVideo = mediaFile.mimeType?.startsWith('video/') ?? false;

    MediaAttachment? thumbnailAttachment;
    if (isVideo) {
      final thumbnail = await ref.read(compressServiceProvider).getThumbnail(mediaFile);
      thumbnailAttachment = await processMedia(thumbnail, masterPubkey);
    }

    final encryptedMediaFile = await ref.read(mediaEncryptionServiceProvider).encryptMediaFile(
          mediaFile,
        );

    final uploadResult = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          encryptedMediaFile.mediaFile,
          alt: FileAlt.message,
          customEventSigner: oneTimeEventSigner,
        );

    final mediaAttachment = uploadResult.mediaAttachment.copyWith(
      blurhash: mediaFile.blurhash,
      encryptionKey: encryptedMediaFile.secretKey,
      encryptionNonce: encryptedMediaFile.nonce,
      encryptionMac: encryptedMediaFile.mac,
      thumb: thumbnailAttachment != null ? jsonEncode(thumbnailAttachment.toJson()) : null,
    );

    final mediaMetadataEvent = await uploadResult.fileMetadata
        .copyWith(
      blurhash: mediaFile.blurhash,
    )
        .toEventMessage(
      oneTimeEventSigner,
      tags: [
        EntityExpiration(
          value: DateTime.now().add(
            Duration(hours: env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS)),
          ),
        ).toTag(),
      ],
    );

    await ref.read(ionConnectNotifierProvider.notifier).sendEvent(
          mediaMetadataEvent,
          actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
          cache: false,
        );

    return mediaAttachment;
  }
}
