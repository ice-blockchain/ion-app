// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/data_sources/get_wallets_data_source.dart';

class GetWalletsService {
  const GetWalletsService(
    this.username,
    this._getWalletsDataSource,
  );

  final String username;
  final GetWalletsDataSource _getWalletsDataSource;

  Future<List<Wallet>> getWallets() async {
    return _getWalletsDataSource.getWallets(username);
  }
}
