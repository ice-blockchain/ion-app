// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:cryptography/cryptography.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/compress_chat_media_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
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
import 'package:ion/app/utils/blurhash.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_chat_media_provider.c.g.dart';

@Riverpod(keepAlive: true)
class SendChatMedia extends _$SendChatMedia {
  CancelableOperation<AsyncValue<List<MediaAttachment>>>? _cancellableOperation;

  @override
  Future<List<MediaAttachment>> build(int id) async {
    return [];
  }

  Future<List<(String, List<MediaAttachment>)>> sendChatMedia(
    List<String> participantsMasterPubkeys,
    MediaFile mediaFile,
  ) async {
    final mediaAttachments = <MediaAttachment>[];
    final result = <(String, List<MediaAttachment>)>[];

    state = const AsyncLoading();

    _cancellableOperation = CancelableOperation.fromFuture(
      AsyncValue.guard(() async {
        final compressedMediaFile = await ref.read(
          compressChatMediaProvider(mediaFile),
        );

        for (final participantKey in participantsMasterPubkeys) {
          if (_cancellableOperation?.isCanceled ?? false) {
            return [];
          }

          final processedAttachments = await processMedia(
            compressedMediaFile,
            participantKey,
          );

          mediaAttachments.addAll(processedAttachments);
          result.add((participantKey, processedAttachments));
        }

        return mediaAttachments;
      }),
    );

    final operation = await _cancellableOperation?.valueOrCancellation(
      const AsyncValue.data([]),
    );

    state = operation!;

    return result;
  }

  Future<void> cancel() async {
    await _cancellableOperation?.cancel();
    await ref.read(messageMediaDaoProvider).cancel(id);
  }

  Future<List<MediaAttachment>> processMedia(
    MediaFile mediaFile,
    String masterPubkey, {
    SecretKey? secretKey,
    List<int>? nonceBytes,
  }) async {
    final mediaAttachments = <MediaAttachment>[];
    final oneTimeEventSigner = await Ed25519KeyStore.generate();
    final env = ref.read(envProvider.notifier);

    final isVideo = mediaFile.mimeType?.startsWith('video/') ?? false;
    final isImage = mediaFile.mimeType?.startsWith('image/') ?? false;

    var blurHash = await generateBlurhash(mediaFile);
    MediaAttachment? thumbMediaAttachment;
    String? thumbUrl;

    if (isVideo) {
      final thumbMediaFile = await ref.read(compressServiceProvider).getThumbnail(mediaFile);
      blurHash = await generateBlurhash(thumbMediaFile);
      thumbMediaAttachment = (await processMedia(thumbMediaFile, masterPubkey)).first;
      mediaAttachments.add(thumbMediaAttachment);
      thumbUrl = thumbMediaAttachment.url;
    }

    final encryptedMediaFile = await ref.read(mediaEncryptionServiceProvider).encryptMediaFile(
          mediaFile,
        );

    final uploadResult = await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
          encryptedMediaFile.mediaFile,
          alt: FileAlt.message,
          customEventSigner: oneTimeEventSigner,
        );

    if (isImage) {
      thumbUrl = uploadResult.mediaAttachment.url;
    }

    final mediaMetadataEvent = await uploadResult.fileMetadata
        .copyWith(
      blurhash: blurHash,
      thumb: thumbUrl,
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

    unawaited(
      ref.read(ionConnectNotifierProvider.notifier).sendEvent(
            mediaMetadataEvent,
            actionSource: ActionSourceUserChat(masterPubkey, anonymous: true),
            cache: false,
          ),
    );

    final mediaAttachment = uploadResult.mediaAttachment.copyWith(
      blurhash: blurHash,
      encryptionKey: encryptedMediaFile.secretKey,
      encryptionNonce: encryptedMediaFile.nonce,
      encryptionMac: encryptedMediaFile.mac,
      thumb: thumbUrl,
    );
    return [
      mediaAttachment,
      ...mediaAttachments,
    ];
  }
}
