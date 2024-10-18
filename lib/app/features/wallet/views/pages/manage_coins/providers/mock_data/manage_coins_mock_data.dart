// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';

List<ManageCoinData> mockedManageCoinsDataArray = mockedCoinsDataArray
    .map(
      (CoinData coinData) => ManageCoinData(coinData: coinData, isSelected: true),
    )
    .toList();
