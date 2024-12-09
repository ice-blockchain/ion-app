// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/data_sources/get_wallet_nfts_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/models/wallet_nfts.c.dart';

class GetWalletNftsService {
  const GetWalletNftsService(
    this.username,
    this._getWalletNftsDataSource,
  );

  final String username;
  final GetWalletNftsDataSource _getWalletNftsDataSource;

  Future<WalletNfts> getWalletNfts(String walletId) async {
    return _getWalletNftsDataSource.getWalletNfts(username, walletId);
  }
}
