// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uri_to_file/uri_to_file.dart';

part 'banuba_service.c.freezed.dart';
part 'banuba_service.c.g.dart';

@freezed
sealed class BanubaEditorState with _$BanubaEditorState {
  const factory BanubaEditorState.idle() = BanubaEditorIdle;
  const factory BanubaEditorState.loading() = BanubaEditorLoading;
  const factory BanubaEditorState.ready({String? videoPath}) = BanubaEditorReady;
  const factory BanubaEditorState.error([String? message]) = BanubaEditorError;
}

class BanubaService {
  const BanubaService(this.env);
  final Env env;

  static const platformChannel = MethodChannel('banubaSdkChannel');

  static const methodInitPhotoEditor = 'initPhotoEditor';
  static const methodStartPhotoEditor = 'startPhotoEditor';
  static const argExportedPhotoFile = 'argExportedPhotoFilePath';

  static const methodInitVideoEditor = 'initVideoEditor';
  static const methodStartVideoEditor = 'startVideoEditor';
  static const argExportedVideoFile = 'argExportedVideoFilePath';

  Future<void> _initEditor(String initMethod) async {
    final token = env.get<String>(EnvVariable.BANUBA_TOKEN);
    await platformChannel.invokeMethod(initMethod, token);
  }

  Future<String> _editMedia({
    required String initMethod,
    required String startMethod,
    required String filePath,
    required String argumentKey,
    required String resultKey,
    Future<String> Function(String)? transform,
  }) async {
    await _initEditor(initMethod);
    final result = await platformChannel.invokeMethod(
      startMethod,
      {argumentKey: filePath},
    );
    if (result is Map) {
      final exportedFilePath = result[resultKey];
      if (exportedFilePath is String) {
        if (transform != null) {
          return transform(exportedFilePath);
        }
        return exportedFilePath;
      }
    }
    return filePath;
  }

  Future<String> editPhoto(String filePath) async {
    try {
      return await _editMedia(
        initMethod: methodInitPhotoEditor,
        startMethod: methodStartPhotoEditor,
        filePath: filePath,
        argumentKey: 'imagePath',
        resultKey: argExportedPhotoFile,
        transform: Platform.isAndroid ? (String path) async => (await toFile(path)).path : null,
      );
    } on PlatformException catch (e, st) {
      Logger.log('Start Photo Editor error', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<String> editVideo(String filePath) async {
    return _editMedia(
      initMethod: methodInitVideoEditor,
      startMethod: methodStartVideoEditor,
      filePath: filePath,
      argumentKey: 'videoURL',
      resultKey: argExportedVideoFile,
    );
  }

  Future<String?> startEditor({String? videoPath}) async {
    await _initEditor(methodInitVideoEditor);
    final arguments = videoPath != null ? {'videoURL': videoPath} : null;
    final result = await platformChannel.invokeMethod(
      methodStartVideoEditor,
      arguments,
    );
    if (result is Map) {
      final path = result[argExportedVideoFile];
      if (path is String) {
        return path;
      }
    }
    return null;
  }
}

@riverpod
BanubaService banubaService(Ref ref) {
  return BanubaService(ref.watch(envProvider.notifier));
}

@riverpod
Future<String> editMedia(Ref ref, MediaFile mediaFile) async {
  final filePath = await ref.read(assetFilePathProvider(mediaFile.path).future);
  if (filePath == null) {
    Logger.log(
      'File path or mime type is null',
      error: mediaFile,
      stackTrace: StackTrace.current,
    );
    throw AssetEntityFileNotFoundException();
  }
  final mimeType = mediaFile.mimeType;
  if (mimeType == null) {
    Logger.log(
      'Mime type is null',
      error: mediaFile,
      stackTrace: StackTrace.current,
    );
    throw AssetEntityFileNotFoundException();
  }

  final mediaType = MediaType.fromMimeType(mimeType);
  switch (mediaType) {
    case MediaType.image:
      return ref.read(banubaServiceProvider).editPhoto(filePath);
    case MediaType.video:
      return ref.read(banubaServiceProvider).editVideo(filePath);
    case MediaType.unknown || MediaType.audio:
      throw Exception('Unknown media type');
  }
}

@riverpod
class BanubaEditorNotifier extends _$BanubaEditorNotifier {
  @override
  BanubaEditorState build() => const BanubaEditorState.idle();

  Future<void> startEditor({String? videoPath}) async {
    state = const BanubaEditorState.loading();
    try {
      final result = await ref.read(banubaServiceProvider).startEditor(videoPath: videoPath);
      state = BanubaEditorState.ready(videoPath: result);
    } catch (e, st) {
      Logger.log('Error starting Banuba Editor', error: e, stackTrace: st);
      state = BanubaEditorState.error(e.toString());
    }
  }
}
