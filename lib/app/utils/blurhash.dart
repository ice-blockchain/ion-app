// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:blurhash_ffi/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

Future<String?> generateBlurhash(MediaFile mediaFile) async {
  try {
    if (mediaFile.mimeType == null) {
      return null;
    }

    final mimeType = MediaType.fromMimeType(mediaFile.mimeType!);
    if (mimeType != MediaType.image) {
      return null;
    }

    final file = File(mediaFile.path);
    if (!file.existsSync()) {
      return null;
    }

    final image = FileImage(file);
    return BlurhashFFI.encode(image);
  } catch (error) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType, error: error);
  }
}
