// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/wallet_view_data.c.dart';

const String mockWalletIconUrl =
    'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png';

const mockedWalletDataArray = [
  WalletViewData(
    id: '1',
    name: 'ice.wallet',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
    balance: 36594.33,
    address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
  ),
  WalletViewData(
    id: '2',
    name: 'Airdrop wallet',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-15.png',
    balance: 48,
    address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
  ),
  WalletViewData(
    id: '3',
    name: 'For transfers',
    icon: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-14.png',
    balance: 279.99,
    address: '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
  ),
];
