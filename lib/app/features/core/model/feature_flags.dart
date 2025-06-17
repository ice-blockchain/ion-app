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
  static const showSuggestions = FeedFeatureFlag._(key: 'showSuggestions');
  static const concurrentDownloadLimit = FeedFeatureFlag._(key: 'concurrentDownloadsLimit');
}

final class LoggerFeatureFlag extends FeatureFlag {
  const LoggerFeatureFlag._({required super.key});

  static const logApp = FeedFeatureFlag._(key: 'logApp');
  static const logRouters = FeedFeatureFlag._(key: 'logRouters');
  static const logIonConnect = FeedFeatureFlag._(key: 'logIonConnect');
  static const logIonIdentityClient = FeedFeatureFlag._(key: 'logIonIdentityClient');
}

final class ChatFeatureFlag extends FeatureFlag {
  const ChatFeatureFlag._({required super.key});

  static const hideCommunity = ChatFeatureFlag._(key: 'hideCommunity');
  static const hideChatBookmark = ChatFeatureFlag._(key: 'hideChatBookmark');
}
