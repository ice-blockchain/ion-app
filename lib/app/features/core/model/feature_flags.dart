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
}
