// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/data/models/media_type.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/app/services/providers/compressors/audio_compressor.c.dart';
import 'package:ion/app/services/providers/compressors/brotli_compressor.c.dart';
import 'package:ion/app/services/providers/compressors/image_compressor.c.dart';
import 'package:ion/app/services/providers/compressors/video_compressor.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compressor.c.g.dart';

abstract interface class Compressor<CompressionSettings> {
  Future<MediaFile> compress(
    MediaFile file, {
    CompressionSettings settings,
  });
}

@riverpod
Compressor<dynamic> compressor(Ref ref, MediaType type) {
  return switch (type) {
    MediaType.image => ref.watch(imageCompressorProvider),
    MediaType.video => ref.watch(videoCompressorProvider),
    MediaType.audio => ref.watch(audioCompressorProvider),
    MediaType.unknown => ref.watch(brotliCompressorProvider),
  };
}
