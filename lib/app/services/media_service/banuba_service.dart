// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

part 'banuba_service.g.dart';

class BanubaService {
  const BanubaService(this.env);
  final Env env;

  // For Photo Editor
  static const methodInitPhotoEditor = 'initPhotoEditor';
  static const methodStartPhotoEditor = 'startPhotoEditor';
  static const argExportedPhotoFile = 'argExportedPhotoFilePath';

  static const platformChannel = MethodChannel('banubaSdkChannel');

  Future<void> _initPhotoEditor() async {
    await platformChannel.invokeMethod(
      methodInitPhotoEditor,
      env.get<String>(EnvVariable.BANUBA_TOKEN),
    );
  }

  Future<String> startPhotoEditor(String filePath) async {
    try {
      await _initPhotoEditor();

      final dynamic result = await platformChannel.invokeMethod(
        methodStartPhotoEditor,
        {'imagePath': filePath},
      );

      if (result is Map) {
        final exportedPhotoFilePath = result[argExportedPhotoFile];
        return exportedPhotoFilePath as String? ?? filePath;
      }
      return filePath;
    } on PlatformException catch (e) {
      Logger.log('Start Photo Editor error', error: e, stackTrace: StackTrace.current);
      rethrow;
    }
  }

  Future<String> openTrimmerScreen(String filePath) async {
    final config = FeaturesConfigBuilder().build();

    final exportResult = await VeSdkFlutter().openTrimmerScreen(
      env.get<String>(EnvVariable.BANUBA_TOKEN),
      config,
      [filePath],
    );

    return exportResult?.videoSources.first ?? filePath;
  }
}

@riverpod
BanubaService banubaService(Ref ref) {
  return BanubaService(ref.watch(envProvider.notifier));
}
