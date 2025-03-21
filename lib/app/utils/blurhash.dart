import 'dart:io';

import 'package:blurhash_ffi/blurhash.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

Future<String> generateBlurhash(MediaFile mediaFile) async {
  if (mediaFile.mimeType == null) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType);
  }

  final mimeType = MediaType.fromMimeType(mediaFile.mimeType!);
  if (mimeType != MediaType.image) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType);
  }

  final file = File(mediaFile.path);
  if (!file.existsSync()) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType);
  }

  try {
    final image = FileImage(file);
    return BlurhashFFI.encode(image);
  } catch (error) {
    throw MediaBlurhashCannotBeGeneratedException(mediaFile.mimeType, error: error);
  }
}
