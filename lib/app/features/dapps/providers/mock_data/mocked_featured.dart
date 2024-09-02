import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/generated/assets.gen.dart';

const _description = '''
OpenSea is the world's first and largest web3 marketplace for NFTs and crypto 
collectibles. Browse, create, buy, sell, and auction NFTs using the variety of 
cryptocurrencies, including Ethereum, Polygon, and Klaytn. OpenSea is a 
decentralized marketplace that is a one-stop-shop for NFTs, with the largest 
selection of NFTs and rare digital items. OpenSea is a decentralized 
marketplace that is a one-stop-shop for NFTs, with the largest selection of 
NFTs and rare digital items. OpenSea is a decentralized marketplace that is a 
one-stop-shop for NFTs, with the largest selection of NFTs and rare digital 
items. OpenSea is a decentralized marketplace that is a one-stop-shop for NFTs, 
with the largest selection of NFTs and rare digital items. OpenSea is a 
decentralized marketplace that is a one-stop-shop for NFTs, with the largest 
selection of NFTs and rare digital items. OpenSea is a decentralized 
marketplace that is a one-stop-shop for NFTs, with the largest selection of 
NFTs and rare digital items. OpenSea is a decentralized marketplace that is a 
one-stop-shop for NFTs, with the largest selection of NFTs and rare digital 
items. OpenSea is a decentralized marketplace that is a one-stop-shop for 
NFTs, with the largest selection of NFTs and rare digital items.''';

List<DAppData> mockedFeatured = <DAppData>[
  DAppData(
    identifier: 1,
    backgroundImage: Assets.images.bg.bgWalletUniswap.path,
    iconImage: Assets.images.wallet.walletUniswap1.path,
    title: 'Uniswap wallet',
    description: 'Buy & trade top tokens',
  ),
  DAppData(
    identifier: 2,
    backgroundImage: Assets.images.bg.bgWallet1inch.path,
    iconImage: Assets.images.wallet.wallet1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
  ),
  DAppData(
    identifier: 3,
    backgroundImage: Assets.images.bg.bgWalletOpensea.path,
    iconImage: Assets.images.wallet.walletOpensea.path,
    title: 'Opensea',
    description: 'Buy & trade top tokens',
    fullDescription: _description,
    link: 'opensea.io',
    value: 3938.25,
  ),
];
