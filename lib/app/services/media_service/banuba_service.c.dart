// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uri_to_file/uri_to_file.dart';

part 'banuba_service.c.g.dart';

class BanubaService {
  const BanubaService(this.env);
  final Env env;

  // For Photo Editor
  static const methodInitPhotoEditor = 'initPhotoEditor';
  static const methodStartPhotoEditor = 'startPhotoEditor';
  static const argExportedPhotoFile = 'argExportedPhotoFilePath';

  // For Video Editor
  static const methodInitVideoEditor = 'initVideoEditor';
  static const methodStartVideoEditor = 'startVideoEditor';
  static const methodStartVideoEditorTrimmer = 'startVideoEditorTrimmer';
  static const argExportedVideoFile = 'argExportedVideoFilePath';

  static const platformChannel = MethodChannel('banubaSdkChannel');

  Future<void> _initPhotoEditor() async {
    await platformChannel.invokeMethod(
      methodInitPhotoEditor,
      env.get<String>(EnvVariable.BANUBA_TOKEN),
    );
  }

  Future<String> editPhoto(String filePath) async {
    try {
      await _initPhotoEditor();

      final dynamic result = await platformChannel.invokeMethod(
        methodStartPhotoEditor,
        {'imagePath': filePath},
      );

      if (result is Map) {
        final exportedPhotoFilePath = result[argExportedPhotoFile];

        if (exportedPhotoFilePath == null) {
          return filePath;
        }

        if (Platform.isAndroid) {
          final file = await toFile(exportedPhotoFilePath as String);
          return file.path;
        }

        return exportedPhotoFilePath as String;
      }
      return filePath;
    } on PlatformException catch (e) {
      Logger.log(
        'Start Photo Editor error',
        error: e,
        stackTrace: StackTrace.current,
      );
      rethrow;
    }
  }

  Future<String> editVideo(String filePath) async {
    await platformChannel.invokeMethod(
      methodInitVideoEditor,
      env.get<String>(EnvVariable.BANUBA_TOKEN),
    );

    final result = await platformChannel.invokeMethod(
      methodStartVideoEditorTrimmer,
      filePath,
    );

    if (result is Map) {
      final exportedVideoFilePath = result[argExportedVideoFile];
      return exportedVideoFilePath as String;
    }
    return filePath;
  }
}

@Riverpod(keepAlive: true)
BanubaService banubaService(Ref ref) {
  return BanubaService(ref.watch(envProvider.notifier));
}

@riverpod
Future<String> editMedia(Ref ref, MediaFile mediaFile) async {
  String? filePath;

  if (path.isAbsolute(mediaFile.path)) {
    filePath = mediaFile.path;
  } else {
    filePath = await ref.read(assetFilePathProvider(mediaFile.path).future);
  }

  if (filePath == null) {
    Logger.log(
      'File path or mime type is null',
      error: mediaFile,
      stackTrace: StackTrace.current,
    );
    throw AssetEntityFileNotFoundException();
  }

  if (mediaFile.mimeType == null) {
    Logger.log(
      'Mime type is null',
      error: mediaFile,
      stackTrace: StackTrace.current,
    );
    throw AssetEntityFileNotFoundException();
  }

  final mediaType = MediaType.fromMimeType(mediaFile.mimeType!);

  switch (mediaType) {
    case MediaType.image:
      return ref.read(banubaServiceProvider).editPhoto(filePath);
    case MediaType.video:
      return ref.read(banubaServiceProvider).editVideo(filePath);
    case MediaType.unknown || MediaType.audio:
      throw Exception('Unknown media type');
  }
}
