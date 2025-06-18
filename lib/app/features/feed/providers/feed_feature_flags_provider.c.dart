// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_feature_flags_provider.c.g.dart';

@Riverpod(keepAlive: true)
class FeedFeatureFlags extends _$FeedFeatureFlags {
  @override
  Map<FeedFeatureFlag, dynamic> build() {
    return {
      FeedFeatureFlag.concurrentDownloadLimit: 3,
    };
  }

  T get<T>(FeedFeatureFlag flag) => state[flag] as T;
}
