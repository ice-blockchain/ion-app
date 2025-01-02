// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flags_provider.c.g.dart';

abstract class FeatureFlagsService {
  const FeatureFlagsService();

  bool? get(FeatureFlag flag);
}

final class LocalFeatureFlagsService extends FeatureFlagsService {
  factory LocalFeatureFlagsService() {
    return LocalFeatureFlagsService._({
      WalletFeatureFlag.buyNftEnabled.key: false,
      FeedFeatureFlag.showTrendingVideo.key: false,
    });
  }

  const LocalFeatureFlagsService._(this._featuresMap);

  final Map<String, bool> _featuresMap;

  @override
  bool? get(FeatureFlag flag) => _featuresMap[flag.key];
}

@Riverpod(keepAlive: true)
class FeatureFlags extends _$FeatureFlags {
  late final FeatureFlagsService _service;

  @override
  Future<void> build() async {
    _service = LocalFeatureFlagsService();
  }

  bool _get(FeatureFlag flag) {
    final value = _service.get(flag);

    if (value == null) {
      throw FeatureFlagNotFound(flag: flag.key);
    }

    return value;
  }

  bool getWalletFlag(WalletFeatureFlag flag) => _get(flag);

  bool getFeedFlag(FeedFeatureFlag flag) => _get(flag);
}
