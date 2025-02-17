// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/model/manage_nft_network_data.c.dart';

Set<ManageNftNetworkData> mockedManageNftsNetworkDataSet = Network.all
    .map(
      (Network network) => ManageNftNetworkData(
        isSelected: false,
        network: network,
      ),
    )
    .toSet();
