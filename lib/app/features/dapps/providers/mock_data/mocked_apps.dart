// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/generated/assets.gen.dart';

const _description =
    '''A decentralized application (dApp) leveraging blockchain technology to provide secure, transparent, and user-driven services without the need for intermediaries. It operates autonomously with smart contracts, ensuring trustless interactions and data integrity. The dApp is designed for scalability, offering a seamless user experience, and supporting various use cases like finance, gaming, and supply chain management.''';

List<DAppData> mockedApps = <DAppData>[
  DAppData(
    identifier: 1,
    iconImage: Assets.images.wallet.walletUniswap.path,
    backgroundImage: Assets.images.bg.bgWalletUniswap.path,
    title: 'Uniswap',
    description: 'Swap ERC-20 tokens',
    value: 4190.77,
    isVerified: true,
    isFavourite: true,
    fullDescription: _description,
    isFeatured: true,
    link: 'uniswap.io',
  ),
  DAppData(
    identifier: 2,
    iconImage: Assets.images.wallet.walletOpensea.path,
    backgroundImage: Assets.images.bg.bgWalletOpensea.path,
    title: 'Opensea',
    description: 'NFT marketplace',
    value: 3938.25,
    isVerified: true,
    isFavourite: true,
    fullDescription: _description,
    isFeatured: true,
    link: 'opensea.io',
  ),
  DAppData(
    identifier: 3,
    iconImage: Assets.images.wallet.wallet1inch.path,
    backgroundImage: Assets.images.bg.bgWallet1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
    value: 2681.49,
    isFavourite: true,
    fullDescription: _description,
    isFeatured: true,
    link: '1inch.io',
  ),
  DAppData(
    identifier: 4,
    iconImage: Assets.images.wallet.walletPanecakeswap.path,
    backgroundImage: Assets.images.bg.bgWalletOpensea.path,
    title: 'Pancakeswap',
    description: 'BSC decentralized exchange',
    value: 1348.52,
    isFavourite: true,
    fullDescription: _description,
  ),
  DAppData(
    identifier: 5,
    iconImage: Assets.images.wallet.walletStargate.path,
    backgroundImage: Assets.images.bg.bgWalletOpensea.path,
    title: 'Stargate',
    description: 'Cross-chain transaction facilitator',
    value: 938.25,
    isFavourite: true,
    fullDescription: _description,
  ),
  DAppData(
    identifier: 6,
    iconImage: Assets.images.wallet.walletLido.path,
    backgroundImage: Assets.images.bg.bgWalletOpensea.path,
    title: 'Lido',
    description: 'Decentralized ETH 2.0.0.staking',
    value: 497.08,
    isFavourite: true,
    fullDescription: _description,
  ),
];
