// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/model/manage_nft_network_data.dart';

Set<ManageNftNetworkData> mockedManageNftsNetworkDataSet = NetworkType.values
    .map(
      (NetworkType networkType) => ManageNftNetworkData(
        isSelected: networkType == NetworkType.all,
        networkType: networkType,
      ),
    )
    .toSet();
