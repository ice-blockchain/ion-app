// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/coins/models/coin.f.dart';
import 'package:ion_identity_client/src/coins/services/get_coin_data/data_sources/get_coin_data_data_source.dart';

class GetCoinDataService {
  GetCoinDataService({
    required GetCoinDataDataSource getCoinDataDataSource,
  }) : _getCoinDataDataSource = getCoinDataDataSource;

  final GetCoinDataDataSource _getCoinDataDataSource;

  Future<Coin> getCoinData({
    required String contractAddress,
    required String network,
  }) {
    return _getCoinDataDataSource.getCoinData(
      contractAddress: contractAddress,
      network: network,
    );
  }
}
