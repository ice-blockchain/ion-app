import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_message_load_media_provider.c.g.dart';

@riverpod
Raw<Future<File?>> chatMessageLoadMedia(
  Ref ref, {
  required PrivateDirectMessageData entity,
  String? cacheKey,
  MediaAttachment? mediaAttachment,
}) async {
  if (cacheKey != null) {
    final cachedFile = await ref.watch(mediaServiceProvider).getFileFromAppDirectory(cacheKey);

    if (cachedFile != null) {
      return cachedFile;
    }
  }

  // If no cached file and no media attachment, exit
  if (mediaAttachment == null) {
    return null;
  }

  // Get thumbnail from media attachments
  final thumb = entity.media.values.firstWhere(
    (e) => e.url == mediaAttachment.thumb,
  );

  // Load encrypted thumbnail
  final encryptedMedia =
      await ref.watch(mediaEncryptionServiceProvider).retrieveEncryptedMedia(thumb);

  return encryptedMedia;
}
