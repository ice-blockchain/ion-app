// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flags_provider.c.g.dart';

@Riverpod(keepAlive: true)
class FeatureFlags extends _$FeatureFlags {
  @override
  Map<FeatureFlag, bool> build() {
    return {
      /// Local flags
      WalletFeatureFlag.buyNftEnabled: false,
      WalletFeatureFlag.dappsEnabled: false,
      FeedFeatureFlag.showTrendingVideo: true,
      FeedFeatureFlag.showMentionsSuggestions: true,
      UsersFeatureFlag.hideCreatorsWithoutPicture: true,
      ChatFeatureFlag.hideCommunity: true,
      ChatFeatureFlag.hideChatBookmark: true,

      /// Log flags
      if (ref.watch(envProvider.notifier).get(EnvVariable.SHOW_DEBUG_INFO)) ...{
        LoggerFeatureFlag.logApp: true,
        LoggerFeatureFlag.logRouters: false,
        LoggerFeatureFlag.logIonConnect: false,
        LoggerFeatureFlag.logIonIdentityClient: false,
      },
    };
  }

  bool get(FeatureFlag flag) => state[flag] ?? false;
}
