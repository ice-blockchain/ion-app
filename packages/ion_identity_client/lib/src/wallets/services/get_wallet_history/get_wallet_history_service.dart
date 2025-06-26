// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/get_wallet_history/data_sources/get_wallet_history_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/models/wallet_history.f.dart';

class GetWalletHistoryService {
  const GetWalletHistoryService(
    this.username,
    this._getWalletHistoryDataSource,
  );

  final String username;
  final GetWalletHistoryDataSource _getWalletHistoryDataSource;

  Future<WalletHistory> getWalletHistory(
    String walletId, {
    String? pageToken,
    int? pageSize,
  }) async {
    return _getWalletHistoryDataSource.getWalletHistory(
      username,
      walletId,
      pageToken: pageToken,
      pageSize: pageSize,
    );
  }
}
