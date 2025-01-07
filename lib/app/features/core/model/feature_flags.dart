// SPDX-License-Identifier: ice License 1.0

sealed class FeatureFlag {
  const FeatureFlag({required this.key});

  final String key;
}

final class WalletFeatureFlag extends FeatureFlag {
  const WalletFeatureFlag._({required super.key});

  static const buyNftEnabled = WalletFeatureFlag._(key: 'buyNftEnabled');
}

final class FeedFeatureFlag extends FeatureFlag {
  const FeedFeatureFlag._({required super.key});

  static const showTrendingVideo = FeedFeatureFlag._(key: 'showTrendingVideo');
  static const showMentionsSuggestions = FeedFeatureFlag._(key: 'showMentionsSuggestions');
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
