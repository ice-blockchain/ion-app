// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:blurhash_ffi/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/compressors/video_compressor.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blurhash_service.r.g.dart';

@Riverpod(keepAlive: true)
Raw<Future<String?>> generateBlurhash(Ref ref, MediaFile mediaFile) async {
  try {
    if (mediaFile.mimeType == null) {
      return null;
    }

    final mimeType = MediaType.fromMimeType(mediaFile.mimeType!);

    if (mimeType == MediaType.image) {
      final file = File(mediaFile.path);
      if (!file.existsSync()) {
        return null;
      }
      final image = FileImage(file);
      return BlurhashFFI.encode(image);
    }

    if (mimeType == MediaType.video) {
      final videoCompressor = ref.read(videoCompressorProvider);

      try {
        final thumbnailFile = await videoCompressor.getThumbnail(mediaFile);
        final thumbnailImage = FileImage(File(thumbnailFile.path));
        return BlurhashFFI.encode(thumbnailImage);
      } catch (e) {
        Logger.log('Failed to generate blurhash for video', error: e);
        return null;
      }
    }

    return null;
  } catch (error) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType, error: error);
  }
}
