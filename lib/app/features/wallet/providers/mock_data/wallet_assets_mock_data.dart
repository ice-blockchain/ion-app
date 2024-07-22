// ignore_for_file: lines_longer_than_80_chars

import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/generated/assets.gen.dart';

List<CoinData> mockedCoinsDataArray = <CoinData>[
  CoinData(
    abbreviation: 'BTC',
    name: 'Bitcoin',
    amount: 0.5,
    balance: 14589.42,
    iconUrl: Assets.images.wallet.walletBtc,
  ),
  CoinData(
    abbreviation: 'ICE',
    name: 'ice Network',
    amount: 10000,
    balance: 9500,
    iconUrl: Assets.images.wallet.walletIce,
  ),
  CoinData(
    abbreviation: 'ETH',
    name: 'Ethereum',
    amount: 1.17,
    balance: 2010.35,
    iconUrl: Assets.images.wallet.walletEth,
  ),
  CoinData(
    abbreviation: 'USDT',
    name: 'TetherUS',
    amount: 100,
    balance: 99.99,
    iconUrl: Assets.images.wallet.walletTether,
  ),
  CoinData(
    abbreviation: 'USDC',
    name: 'USDC',
    amount: 100,
    balance: 99.99,
    iconUrl: Assets.images.wallet.walletUsdc,
  ),
  CoinData(
    abbreviation: 'Polygon',
    name: 'MATIC',
    amount: 1000,
    balance: 694.60,
    iconUrl: Assets.images.wallet.walletMatic,
  ),
  CoinData(
    abbreviation: 'XRP',
    name: 'XRP',
    amount: 0,
    balance: 0,
    iconUrl: Assets.images.wallet.walletXrp,
  ),
  CoinData(
    abbreviation: 'LTC',
    name: 'Litecoin',
    amount: 350,
    balance: 589.42,
    iconUrl: Assets.images.wallet.walletLtc,
  ),
];

const List<NftData> mockedNftsDataArray = <NftData>[
  NftData(
    collectionName: 'WZRD',
    identifier: 67,
    price: 2.11,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-10.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Explore the mysteries of the universe with WZRD! This hand-drawn, one-of-a-kind digital artwork features a whimsical feline adorned with interstellar patterns and vibrant colors. Perfect for space enthusiasts and cat lovers alike, this NFT brings a touch of the cosmos to your collection. Own a piece of digital space art today!',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 1,
  ),
  NftData(
    collectionName: 'Moonrunners Specialty',
    identifier: 4,
    price: 3.87,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-11.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Step into a world of electric hues and surreal landscapes with Moonrunners Specialty. This unique digital painting captures the essence of a futuristic city bathed in neon lights. With its intricate details and vivid colors, this NFT promises to be a standout addition to any digital art collection. Embrace the future with Moonrunners Specialty.',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 2,
  ),
  NftData(
    collectionName: 'Crazy Monkey',
    identifier: 456,
    price: 0.04,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-12.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Behold the Crazy Monkey, a mesmerizing 3D digital sculpture that exudes mystery and power. Crafted with intricate textures and lifelike details, this NFT represents a mythical protector from a forgotten era. Perfect for collectors of fantasy and mythology, Crazy Monkey is a testament to digital artistry at its finest.',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 3,
  ),
  NftData(
    collectionName: 'Metaverse Melody',
    identifier: 76,
    price: 1.34,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-13.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Experience the harmony of the digital world with Metaverse Melody, a dynamic audio-visual NFT. This piece combines stunning visuals with an original soundtrack, creating an immersive experience that transports you to the heart of the metaverse. Ideal for those who appreciate both visual and auditory art forms, Metaverse Melody is a symphony for the senses.',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 4,
  ),
  NftData(
    collectionName: 'Ethereal Butterfly',
    identifier: 345,
    price: 0,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Delicate and enchanting, Ethereal Butterfly is a digital artwork that captures the ephemeral beauty of a butterfly in flight. With its shimmering wings and vibrant colors, this NFT is a symbol of transformation and freedom. Perfect for nature lovers and art enthusiasts, Ethereal Butterfly adds a touch of grace and elegance to any collection.',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 5,
  ),
  NftData(
    collectionName: 'Pixel Samurai',
    identifier: 19,
    price: 0.05,
    iconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    currency: 'ETH',
    currencyIconUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
    description:
        'Unleash the warrior within with Pixel Samurai, a striking 8-bit digital artwork that combines classic retro gaming aesthetics with the fierce elegance of a samurai. This NFT features a meticulously designed warrior poised for battle, set against a backdrop of traditional Japanese elements. Perfect for fans of retro gaming and martial arts, Pixel Samurai brings a blend of nostalgia and artistry to your digital collection.',
    network: 'Ethereum',
    tokenStandard: 'ERC-1123',
    contractAddress: '0x4559...4jd83g',
    rank: 6,
  ),
];
