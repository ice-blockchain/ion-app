// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/compressors/audio_compressor.r.dart';
import 'package:ion/app/services/compressors/brotli_compressor.r.dart';
import 'package:ion/app/services/compressors/image_compressor.r.dart';
import 'package:ion/app/services/compressors/video_compressor.r.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'compressor.r.g.dart';

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
