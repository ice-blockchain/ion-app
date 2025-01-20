// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/model/manage_nft_network_data.c.dart';

Set<ManageNftNetworkData> mockedManageNftsNetworkDataSet = NetworkType.values
    .map(
      (NetworkType networkType) => ManageNftNetworkData(
        isSelected: networkType == NetworkType.all,
        networkType: networkType,
      ),
    )
    .toSet();
