// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';

const String mockWalletIconUrl =
    'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png';

const mockedWalletDataArray = <WalletViewData>[
  WalletViewData(
    id: '1',
    name: 'ice.wallet',
    usdBalance: 36594.33,
    coinGroups: [],
    createdAt: '',
    updatedAt: '',
    symbolGroups: {},
    isMainWalletView: false,
  ),
  WalletViewData(
    id: '2',
    name: 'Airdrop wallet',
    usdBalance: 48,
    coinGroups: [],
    createdAt: '',
    updatedAt: '',
    symbolGroups: {},
    isMainWalletView: false,
  ),
  WalletViewData(
    id: '3',
    name: 'For transfers',
    usdBalance: 279.99,
    coinGroups: [],
    createdAt: '',
    updatedAt: '',
    symbolGroups: {},
    isMainWalletView: false,
  ),
];

const mockedNetwork = NetworkData(
  id: 'IonTestnet',
  image:
      'https://assets.coingecko.com/coins/images/34674/standard/ion-coingecko-200w.png?1714009819',
  isTestnet: true,
  displayName: 'ION',
  explorerUrl: 'https://explorer.testnet.ice.io/address/{txHash}',
);
