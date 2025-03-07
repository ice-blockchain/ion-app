// SPDX-License-Identifier: ice License 1.0

sealed class FeatureFlag {
  const FeatureFlag({required this.key});

  final String key;
}

final class WalletFeatureFlag extends FeatureFlag {
  const WalletFeatureFlag._({required super.key});

  static const buyNftEnabled = WalletFeatureFlag._(key: 'buyNftEnabled');
  static const dappsEnabled = WalletFeatureFlag._(key: 'dappsEnabled');
}

final class FeedFeatureFlag extends FeatureFlag {
  const FeedFeatureFlag._({required super.key});

  static const showTrendingVideo = FeedFeatureFlag._(key: 'showTrendingVideo');
  static const showMentionsSuggestions = FeedFeatureFlag._(key: 'showMentionsSuggestions');
}

final class LoggerFeatureFlag extends FeatureFlag {
  const LoggerFeatureFlag._({required super.key});

  static const logApp = FeedFeatureFlag._(key: 'logApp');
  static const logRouters = FeedFeatureFlag._(key: 'logRouters');
  static const logIonConnect = FeedFeatureFlag._(key: 'logIonConnect');
  static const logIonIdentityClient = FeedFeatureFlag._(key: 'logIonIdentityClient');
}

///
/// TODO: remove this once before production release
/// It hides creators without picture from the discover creators page
///
final class HideCreatorsWithoutPicture extends FeatureFlag {
  const HideCreatorsWithoutPicture._({required super.key});

  static const hideCreatorsWithoutPicture =
      HideCreatorsWithoutPicture._(key: 'hideCreatorsWithoutPicture');
}

final class HideCommunityFeatureFlag extends FeatureFlag {
  const HideCommunityFeatureFlag._({required super.key});

  static const hideCommunity = HideCommunityFeatureFlag._(key: 'hideCommunity');
}

final class HideChatBookmark extends FeatureFlag {
  const HideChatBookmark._({required super.key});

  static const hideChatBookmark = HideChatBookmark._(key: 'hideChatBookmark');
}
