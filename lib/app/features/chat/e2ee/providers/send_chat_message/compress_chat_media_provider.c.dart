// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/compressors/audio_compressor.c.dart';
import 'package:ion/app/services/compressors/brotli_compressor.c.dart';
import 'package:ion/app/services/compressors/image_compressor.c.dart';
import 'package:ion/app/services/compressors/video_compressor.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compress_chat_media_provider.c.g.dart';

@Riverpod(keepAlive: true)
Raw<Future<MediaFile>> compressChatMedia(Ref ref, MediaFile mediaFile) async {
  final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

  switch (mediaType) {
    case MediaType.image:
      return ref.watch(imageCompressorProvider).compressImage(mediaFile, shouldCompressGif: true);
    case MediaType.video:
      return ref.watch(videoCompressorProvider).compressVideo(mediaFile);
    case MediaType.audio:
      return ref.watch(audioCompressorProvider).compressAudio(mediaFile.path);
    case MediaType.unknown:
      return ref.watch(brotliCompressorProvider).compressWithBrotli(File(mediaFile.path));
  }
}
