// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/wallet_views/data_sources/wallet_views_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/create_wallet_view_request.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view.dart';

class WalletViewsService {
  const WalletViewsService(
    this.username,
    this._walletViewsDataSource,
  );

  final String username;
  final WalletViewsDataSource _walletViewsDataSource;

  Future<List<WalletView>> getWalletViews(String userId) async {
    return _walletViewsDataSource.getWalletViews(username, userId);
  }

  Future<WalletView> createWalletView(CreateWalletViewRequest request) async {
    return _walletViewsDataSource.createWalletView(username, request);
  }

  Future<WalletView> getWalletView(String viewName) async {
    return _walletViewsDataSource.getWalletView(username, viewName);
  }

  Future<WalletView> updateWalletView(
    String viewName,
    CreateWalletViewRequest request,
  ) async {
    return _walletViewsDataSource.updateWalletView(username, viewName, request);
  }

  Future<void> deleteWalletView(String viewName) async {
    return _walletViewsDataSource.deleteWalletView(username, viewName);
  }
}
