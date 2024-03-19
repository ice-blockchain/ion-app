import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';

const List<CoinData> mockedCoinsDataArray = <CoinData>[
  CoinData(
    abbreviation: 'BTC',
    name: 'Bitcoin',
    amount: 0.5,
    balance: 14589.42,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-10.png',
  ),
  CoinData(
    abbreviation: 'ICE',
    name: 'ice Network',
    amount: 10000.00,
    balance: 9500.00,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-11.png',
  ),
  CoinData(
    abbreviation: 'ETH',
    name: 'Etherium',
    amount: 1.17,
    balance: 2010.35,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-12.png',
  ),
  CoinData(
    abbreviation: 'USDT',
    name: 'TetherUS',
    amount: 100.00,
    balance: 99.99,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-13.png',
  ),
  CoinData(
    abbreviation: 'Polygon',
    name: 'MATIC',
    amount: 1000.00,
    balance: 694.60,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
  ),
  CoinData(
    abbreviation: 'XRP',
    name: 'XRP',
    amount: 0.00,
    balance: 0.00,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
  ),
  CoinData(
    abbreviation: 'LTC',
    name: 'Litecoin',
    amount: 350.00,
    balance: 589.42,
    iconUrl:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
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

const List<WalletData> mockedWalletDataArray = <WalletData>[
  WalletData(
    id: '1',
    name: 'ice.wallet',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
    balance: 36594.33,
    coins: mockedCoinsDataArray,
    nfts: mockedNftsDataArray,
  ),
  WalletData(
    id: '2',
    name: 'Airdrop wallet',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    balance: 48.00,
    coins: <CoinData>[],
    nfts: mockedNftsDataArray,
  ),
  WalletData(
    id: '3',
    name: 'For transfers',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    balance: 279.99,
    coins: mockedCoinsDataArray,
    nfts: <NftData>[],
  ),
];
