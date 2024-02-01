import 'package:ice/generated/assets.gen.dart';

class DAppItem {
  DAppItem({
    required this.iconImage,
    required this.title,
    this.description = '',
    this.value = 0.0,
    this.isVerified = false,
  });

  final String iconImage;
  final String title;
  final String? description;
  final double? value;
  final bool? isVerified;
}

List<DAppItem> featured = <DAppItem>[
  DAppItem(
    iconImage: Assets.images.walletUniswap.path,
    title: 'Uniswap',
    description: 'Swap ERC-20 tokens',
    value: 4190.77,
    isVerified: true,
  ),
  DAppItem(
    iconImage: Assets.images.walletOpensea.path,
    title: 'Opensea',
    description: 'NFT marketplace',
    value: 3938.25,
    isVerified: true,
  ),
  DAppItem(
    iconImage: Assets.images.wallet1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
    value: 2681.49,
  ),
  DAppItem(
    iconImage: Assets.images.walletPanecakeswap.path,
    title: 'Pancakeswap',
    description: 'BSC decentralized exchange',
    value: 1348.52,
  ),
  DAppItem(
    iconImage: Assets.images.walletStargate.path,
    title: 'Stargate',
    description: 'Cross-chain transaction facilitator',
    value: 938.25,
  ),
  DAppItem(
    iconImage: Assets.images.walletLido.path,
    title: 'Lido',
    description: 'Decentralized ETH 2.0 staking',
    value: 497.08,
  ),
];
