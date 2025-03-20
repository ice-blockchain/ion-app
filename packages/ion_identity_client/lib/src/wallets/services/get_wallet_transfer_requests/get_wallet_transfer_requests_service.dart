// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/data_sources/get_wallet_transfer_requests_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/models/wallet_transfer_request.c.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/models/wallet_transfer_requests.c.dart';

class GetWalletTransferRequestsService {
  const GetWalletTransferRequestsService(
    this.username,
    this._getWalletTransferRequestsDataSource,
  );

  final String username;
  final GetWalletTransferRequestsDataSource _getWalletTransferRequestsDataSource;

  Future<WalletTransferRequests> getWalletTransferRequests(
    String walletId, {
    String? pageToken,
  }) async {
    return _getWalletTransferRequestsDataSource.getWalletTransferRequests(
      username,
      walletId,
      pageToken: pageToken,
    );
  }

  Future<WalletTransferRequest> getWalletTransferRequestById({
    required String walletId,
    required String transferId,
  }) async {
    return _getWalletTransferRequestsDataSource.getWalletTransferRequestById(
      username,
      walletId: walletId,
      transferId: transferId,
    );
  }
}
