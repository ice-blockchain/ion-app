// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
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
    Logger.log('[EDIT_PHOTO] editPhoto called with filePath: $filePath');
    
    try {
      await _initPhotoEditor();

      Logger.log('[EDIT_PHOTO] Calling methodStartPhotoEditor...');
      final dynamic result = await platformChannel.invokeMethod(
        methodStartPhotoEditor,
        {'imagePath': filePath},
      );

      Logger.log('[EDIT_PHOTO] Result from methodStartPhotoEditor: $result');

      if (result == null) {
        Logger.log('[EDIT_PHOTO] User cancelled editing');
        throw PlatformException(
          code: 'USER_CANCELLED',
          message: 'User cancelled photo editing',
        );
      }

      if (result is Map) {
        final exportedPhotoFilePath = result[argExportedPhotoFile];

        if (exportedPhotoFilePath == null) {
          Logger.log('[EDIT_PHOTO] No exported file, returning original path');
          return filePath;
        }

        if (Platform.isAndroid) {
          final file = await toFile(exportedPhotoFilePath as String);
          Logger.log('[EDIT_PHOTO] Exported photo file path (Android): ${file.path}');
          return file.path;
        }

        Logger.log('[EDIT_PHOTO] Exported photo file path: $exportedPhotoFilePath');
        return exportedPhotoFilePath as String;
      }
      
      Logger.log('[EDIT_PHOTO] Unexpected result type, returning original path');
      return filePath;
    } on PlatformException catch (e) {
      Logger.log('[EDIT_PHOTO] Platform exception during photo editing', error: e);
      rethrow;
    }
  }

  Future<String> editVideo(String filePath) async {
    try {
      await platformChannel.invokeMethod(
        methodInitVideoEditor,
        env.get<String>(EnvVariable.BANUBA_TOKEN),
      );

      Logger.log('[EDIT_VIDEO] Calling methodStartVideoEditorTrimmer...');
      final result = await platformChannel.invokeMethod(
        methodStartVideoEditorTrimmer,
        filePath,
      );

      Logger.log('[EDIT_VIDEO] Result from methodStartVideoEditorTrimmer: $result');
      
      if (result == null) {
        Logger.log('[EDIT_VIDEO] User cancelled editing');
        throw PlatformException(
          code: 'USER_CANCELLED',
          message: 'User cancelled video editing',
        );
      }
      
      if (result is Map) {
        final exportedVideoFilePath = result[argExportedVideoFile];
        if (exportedVideoFilePath != null) {
          Logger.log('[EDIT_VIDEO] Exported video file path: $exportedVideoFilePath');
          return exportedVideoFilePath as String;
        }
      }
      
      Logger.log('[EDIT_VIDEO] No exported file, returning original path');
      return filePath;
    } on PlatformException catch (e) {
      Logger.log('[EDIT_VIDEO] Platform exception during video editing', error: e);
      rethrow;
    } catch (e) {
      Logger.log('[EDIT_VIDEO] Unexpected error during video editing', error: e);
      return filePath;
    }
  }
}

@Riverpod(keepAlive: true)
BanubaService banubaService(Ref ref) {
  return BanubaService(ref.watch(envProvider.notifier));
}

@riverpod
Future<String> editMedia(Ref ref, MediaFile mediaFile) async {
  Logger.log('[EDIT_VIDEO] editMedia called with mediaFile.path: ${mediaFile.path}');
  Logger.log('[EDIT_VIDEO] mediaFile.mimeType: ${mediaFile.mimeType}');
  
  // Check if the path is already a file path or an asset ID
  String? filePath;
  
  // Check if it's an absolute file path (starts with '/' for both iOS and Android)
  // or if the file exists at the given path
  final isAbsolutePath = mediaFile.path.startsWith('/') || File(mediaFile.path).existsSync();
  
  if (isAbsolutePath) {
    Logger.log('[EDIT_VIDEO] Path is already a file path, using directly: ${mediaFile.path}');
    filePath = mediaFile.path;
  } else {
    // Otherwise, treat it as an asset ID and get the file path
    Logger.log('[EDIT_VIDEO] Path appears to be an asset ID, fetching file path...');
    filePath = await ref.read(assetFilePathProvider(mediaFile.path).future);
    Logger.log('[EDIT_VIDEO] Fetched file path from asset ID: $filePath');
  }

  if (filePath == null) {
    Logger.log(
      '[EDIT_VIDEO] File path or mime type is null',
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
