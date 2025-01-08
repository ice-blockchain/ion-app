// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flags_provider.c.g.dart';

abstract class FeatureFlagsService {
  const FeatureFlagsService();

  bool? get(FeatureFlag flag);

  Set<FeatureFlag> get supportedFlags;
}

final class LocalFeatureFlagsService extends FeatureFlagsService {
  factory LocalFeatureFlagsService() {
    return const LocalFeatureFlagsService._({
      WalletFeatureFlag.buyNftEnabled: false,
      FeedFeatureFlag.showTrendingVideo: false,
      FeedFeatureFlag.showMentionsSuggestions: false,
      HideCreatorsWithoutPicture.hideCreatorsWithoutPicture: true,
    });
  }

  const LocalFeatureFlagsService._(this._featuresMap);

  final Map<FeatureFlag, bool> _featuresMap;

  @override
  bool? get(FeatureFlag flag) => _featuresMap[flag];

  @override
  Set<FeatureFlag> get supportedFlags => _featuresMap.keys.toSet();
}

final class LoggerFeatureFlagsService extends FeatureFlagsService {
  factory LoggerFeatureFlagsService() {
    return const LoggerFeatureFlagsService._({
      LoggerFeatureFlag.logApp: true,
      LoggerFeatureFlag.logRouters: false,
      LoggerFeatureFlag.logNostrDart: true,
      LoggerFeatureFlag.logIonIdentityClient: true,
    });
  }

  const LoggerFeatureFlagsService._(this._featuresMap);

  final Map<FeatureFlag, bool> _featuresMap;

  @override
  bool? get(FeatureFlag flag) => _featuresMap[flag];

  @override
  Set<FeatureFlag> get supportedFlags => _featuresMap.keys.toSet();
}

@Riverpod(keepAlive: true)
class FeatureFlags extends _$FeatureFlags {
  @override
  Set<FeatureFlagsService> build() {
    final showDebugInfo = ref.read(envProvider.notifier).get<bool>(EnvVariable.SHOW_DEBUG_INFO);

    return {
      LocalFeatureFlagsService(),
      if (showDebugInfo) LoggerFeatureFlagsService(),
    };
  }

  bool get(FeatureFlag flag, {bool defaultValue = false}) {
    for (final service in state) {
      if (service.supportedFlags.contains(flag)) {
        final value = service.get(flag);

        if (value != null) {
          return value;
        }
      }
    }

    Logger.log('${flag.key} not found.');

    return defaultValue;
  }
}
