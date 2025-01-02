// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/coins/models/coins_response.c.dart';
import 'package:ion_identity_client/src/coins/services/data_sources/get_coins_data_source.dart';

class GetCoinsService {
  GetCoinsService({
    required GetCoinsDataSource getCoinsDataSource,
  }) : _getCoinsDataSource = getCoinsDataSource;

  final GetCoinsDataSource _getCoinsDataSource;

  Future<CoinsResponse> getCoins({
    required String username,
    required String userId,
    required int currentVersion,
  }) async {
    return _getCoinsDataSource.getCoins(
      username: username,
      userId: userId,
      currentVersion: currentVersion,
    );
  }
}
