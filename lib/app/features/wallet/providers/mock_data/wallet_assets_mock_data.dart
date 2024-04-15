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
    amount: 10000.00,
    balance: 9500.00,
    iconUrl: Assets.images.wallet.walletIce,
  ),
  CoinData(
    abbreviation: 'ETH',
    name: 'Etherium',
    amount: 1.17,
    balance: 2010.35,
    iconUrl: Assets.images.wallet.walletEth,
  ),
  CoinData(
    abbreviation: 'USDT',
    name: 'TetherUS',
    amount: 100.00,
    balance: 99.99,
    iconUrl: Assets.images.wallet.walletTether,
  ),
  CoinData(
    abbreviation: 'USDC',
    name: 'USDC',
    amount: 100.00,
    balance: 99.99,
    iconUrl: Assets.images.wallet.walletUsdc,
  ),
  CoinData(
    abbreviation: 'Polygon',
    name: 'MATIC',
    amount: 1000.00,
    balance: 694.60,
    iconUrl: Assets.images.wallet.walletMatic,
  ),
  CoinData(
    abbreviation: 'XRP',
    name: 'XRP',
    amount: 0.00,
    balance: 0.00,
    iconUrl: Assets.images.wallet.walletXrp,
  ),
  CoinData(
    abbreviation: 'LTC',
    name: 'Litecoin',
    amount: 350.00,
    balance: 589.42,
    iconUrl: Assets.images.wallet.walletLtc,
  ),
];

const List<NftData> mockedNftsDataArray = <NftData>[
  NftData(
    collectionName: 'WZRD',
    identifier: 67,
    price: 2.11,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-10.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
  NftData(
    collectionName: 'Moonrunners Specialty',
    identifier: 4,
    price: 3.87,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-11.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
  NftData(
    collectionName: 'Crazy Monkey',
    identifier: 456,
    price: 0.04,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-12.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
  NftData(
    collectionName: 'WZRD',
    identifier: 76,
    price: 1.34,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-13.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
  NftData(
    collectionName: 'Lucky Dog',
    identifier: 345,
    price: 0.00,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
  NftData(
    collectionName: 'WZRD',
    identifier: 19,
    price: 0.05,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    currency: 'ETH',
    currencyIconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
  ),
];
