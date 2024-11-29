import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ve_sdk_flutter/features_config.dart';
import 'package:ve_sdk_flutter/ve_sdk_flutter.dart';

part 'banuba_service.g.dart';

@riverpod
Future<String> openTrimmerScreen(Ref ref, String filePath) async {
  final banubaToken = ref.watch(envProvider.notifier).get<String>(EnvVariable.BANUBA_TOKEN);
  final config = FeaturesConfigBuilder().build();

  final exportResult = await VeSdkFlutter().openTrimmerScreen(
    banubaToken,
    config,
    [filePath],
  );

  return exportResult?.videoSources.first ?? filePath;
}
