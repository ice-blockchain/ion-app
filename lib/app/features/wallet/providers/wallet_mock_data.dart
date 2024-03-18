import 'package:ice/app/features/wallet/model/coin_data.dart';
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
    amount: 58.00,
    balance: 43.00,
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

const List<WalletData> mockedWalletDataArray = <WalletData>[
  WalletData(
    id: '1',
    name: 'ice.wallet',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
    balance: 36594.33,
    coins: mockedCoinsDataArray,
  ),
  WalletData(
    id: '2',
    name: 'Airdrop wallet',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    balance: 48.00,
    coins: <CoinData>[],
  ),
  WalletData(
    id: '3',
    name: 'For transfers',
    icon:
        'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    balance: 279.99,
    coins: mockedCoinsDataArray,
  ),
];
