import 'package:ice/generated/assets.gen.dart';

class FeaturedItem {
  FeaturedItem({
    required this.backgroundImage,
    required this.iconImage,
    required this.title,
    required this.description,
  });

  final String backgroundImage;
  final String iconImage;
  final String title;
  final String description;
}

List<FeaturedItem> featured = <FeaturedItem>[
  FeaturedItem(
    backgroundImage: Assets.images.uniswapBg.path,
    iconImage: Assets.images.featuredUniswap.path,
    title: 'Uniswap wallet',
    description: 'Buy & trade top tokens',
  ),
  FeaturedItem(
    backgroundImage: Assets.images.oneInchBg.path,
    iconImage: Assets.images.featured1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
  ),
];
