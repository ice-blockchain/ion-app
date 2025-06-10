// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/models/database/wallets_database.c.dart' as db;
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';

class NetworksMapper {
  List<db.Network> toDb(Iterable<NetworkData> networks) => [
        for (final network in networks)
          db.Network(
            id: network.id,
            displayName: network.displayName,
            explorerUrl: network.explorerUrl,
            image: network.image,
            isTestnet: network.isTestnet,
            tier: network.tier,
          ),
      ];
}
