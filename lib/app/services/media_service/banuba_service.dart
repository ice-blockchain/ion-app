// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

part 'banuba_service.g.dart';

class BanubaService {
  const BanubaService(this.env);
  final Env env;

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
