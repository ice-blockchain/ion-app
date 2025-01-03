// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/feature_flags.dart';
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
    });
  }

  const LocalFeatureFlagsService._(this._featuresMap);

  final Map<FeatureFlag, bool> _featuresMap;

  @override
  bool? get(FeatureFlag flag) => _featuresMap[flag];

  @override
  Set<FeatureFlag> get supportedFlags => _featuresMap.keys.toSet();
}

@Riverpod(keepAlive: true)
class FeatureFlags extends _$FeatureFlags {
  late final Set<FeatureFlagsService> _services;

  @override
  Future<void> build() async {
    _services = {
      LocalFeatureFlagsService(),
    };
  }

  bool get(FeatureFlag flag, {bool defaultValue = false}) {
    for (final service in _services) {
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
