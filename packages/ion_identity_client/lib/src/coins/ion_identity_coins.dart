// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/coins/models/coin.c.dart';
import 'package:ion_identity_client/src/coins/models/coins_response.c.dart';
import 'package:ion_identity_client/src/coins/services/get_coins_service.dart';

class IONIdentityCoins {
  IONIdentityCoins({
    required this.username,
    required GetCoinsService getCoinsService,
    required ExtractUserIdService extractUserIdService,
  })  : _getCoinsService = getCoinsService,
        _extractUserIdService = extractUserIdService;

  final String username;
  final GetCoinsService _getCoinsService;
  final ExtractUserIdService _extractUserIdService;

  Future<CoinsResponse> getCoins({
    required int currentVersion,
  }) {
    final userId = _extractUserIdService.extractUserId(username: username);
    return _getCoinsService.getCoins(
      username: username,
      userId: userId,
      currentVersion: currentVersion,
    );
  }

  Future<List<Coin>> syncCoins(List<Coin> coins) {
    return _getCoinsService.syncCoins(
      username: username,
      coins: coins,
    );
  }
}
