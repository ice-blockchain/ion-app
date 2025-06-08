// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/data/models/media_type.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/app/services/providers/compressors/compressor.c.dart';
import 'package:ion/app/services/providers/compressors/image_compressor.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compress_chat_media_provider.c.g.dart';

@Riverpod(keepAlive: true)
Raw<Future<MediaFile>> compressChatMedia(Ref ref, MediaFile mediaFile) async {
  final mediaType = MediaType.fromMimeType(mediaFile.mimeType ?? '');

  final compressor = ref.watch(compressorProvider(mediaType));
  if (mediaType == MediaType.image) {
    return compressor.compress(
      mediaFile,
      settings: const ImageCompressionSettings(shouldCompressGif: true),
    );
  }

  return compressor.compress(mediaFile);
}
