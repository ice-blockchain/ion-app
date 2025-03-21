// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compress_chat_media_provider.c.g.dart';

@Riverpod(keepAlive: true)
Raw<Future<MediaFile>> compressChatMedia(Ref ref, MediaFile mediaFile) async {
  final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

  final compressService = ref.watch(compressServiceProvider);

  switch (mediaType) {
    case MediaType.image:
      return compressService.compressImage(mediaFile);
    case MediaType.video:
      return compressService.compressVideo(mediaFile);
    case MediaType.audio:
      return compressService.compressAudio(mediaFile.path);
    case MediaType.unknown:
      return compressService.compressWithBrotli(File(mediaFile.path));
  }
}
