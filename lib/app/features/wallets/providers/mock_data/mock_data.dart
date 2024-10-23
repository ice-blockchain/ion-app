// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/wallet_data.dart';

const String mockWalletIconUrl =
    'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png';

const mockedWalletDataArray = [
  WalletData(
    id: '1',
    name: 'ice.wallet',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
    balance: 36594.33,
  ),
  WalletData(
    id: '2',
    name: 'Airdrop wallet',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    balance: 48,
  ),
  WalletData(
    id: '3',
    name: 'For transfers',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    balance: 279.99,
  ),
];
