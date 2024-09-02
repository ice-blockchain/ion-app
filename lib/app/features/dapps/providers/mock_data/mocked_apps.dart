import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/generated/assets.gen.dart';

List<DAppData> mockedApps = <DAppData>[
  DAppData(
    identifier: 1,
    iconImage: Assets.images.wallet.walletUniswap.path,
    title: 'Uniswap',
    description: 'Swap ERC-20 tokens',
    value: 4190.77,
    isVerified: true,
    isFavourite: true,
  ),
  DAppData(
    identifier: 2,
    iconImage: Assets.images.wallet.walletOpensea.path,
    title: 'Opensea',
    description: 'NFT marketplace',
    value: 3938.25,
    isVerified: true,
    isFavourite: true,
  ),
  DAppData(
    identifier: 3,
    iconImage: Assets.images.wallet.wallet1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
    value: 2681.49,
    isFavourite: true,
  ),
  DAppData(
    identifier: 4,
    iconImage: Assets.images.wallet.walletPanecakeswap.path,
    title: 'Pancakeswap',
    description: 'BSC decentralized exchange',
    value: 1348.52,
    isFavourite: true,
  ),
  DAppData(
    identifier: 5,
    iconImage: Assets.images.wallet.walletStargate.path,
    title: 'Stargate',
    description: 'Cross-chain transaction facilitator',
    value: 938.25,
    isFavourite: true,
  ),
  DAppData(
    identifier: 6,
    iconImage: Assets.images.wallet.walletLido.path,
    title: 'Lido',
    description: 'Decentralized ETH 2.0.0.staking',
    value: 497.08,
    isFavourite: true,
  ),
];
