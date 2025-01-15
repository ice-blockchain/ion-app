// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/wallet_views/data_sources/wallet_views_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/create_wallet_view_request.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/short_wallet_view.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view.c.dart';

class WalletViewsService {
  const WalletViewsService(
    this.username,
    this._walletViewsDataSource,
  );

  final String username;
  final WalletViewsDataSource _walletViewsDataSource;

  Future<List<ShortWalletView>> getWalletViews(String userId) async {
    return _walletViewsDataSource.getWalletViews(username, userId);
  }

  Future<ShortWalletView> createWalletView(
      CreateWalletViewRequest request) async {
    return _walletViewsDataSource.createWalletView(username, request);
  }

  Future<WalletView> getWalletView({
    required String userId,
    required String viewName,
  }) async {
    return _walletViewsDataSource.getWalletView(
      userId: userId,
      username: username,
      viewName: viewName,
    );
  }

  Future<ShortWalletView> updateWalletView(
    String viewName,
    CreateWalletViewRequest request,
  ) async {
    return _walletViewsDataSource.updateWalletView(username, viewName, request);
  }

  Future<void> deleteWalletView(String viewName) async {
    return _walletViewsDataSource.deleteWalletView(username, viewName);
  }
}
