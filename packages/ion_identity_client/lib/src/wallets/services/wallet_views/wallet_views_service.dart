// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/wallet_views/data_sources/wallet_views_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/create_update_wallet_view_request.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/short_wallet_view.c.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view.c.dart';

class WalletViewsService {
  const WalletViewsService(
    this.username,
    this._walletViewsDataSource,
  );

  final String username;
  final WalletViewsDataSource _walletViewsDataSource;

  Future<List<ShortWalletView>> getWalletViews(String userId) {
    return _walletViewsDataSource.getWalletViews(username, userId);
  }

  Future<ShortWalletView> createWalletView(
    CreateUpdateWalletViewRequest request,
    String userId,
  ) {
    return _walletViewsDataSource.createWalletView(userId, username, request);
  }

  Future<WalletView> getWalletView({
    required String userId,
    required String walletViewId,
  }) {
    return _walletViewsDataSource.getWalletView(
      userId: userId,
      username: username,
      walletViewId: walletViewId,
    );
  }

  Future<ShortWalletView> updateWalletView(
    String userId,
    String walletViewId,
    CreateUpdateWalletViewRequest request,
  ) {
    return _walletViewsDataSource.updateWalletView(
      userId: userId,
      request: request,
      username: username,
      walletViewId: walletViewId,
    );
  }

  Future<void> deleteWalletView(String walletViewId, String userId) {
    return _walletViewsDataSource.deleteWalletView(
      username,
      userId,
      walletViewId,
    );
  }
}
