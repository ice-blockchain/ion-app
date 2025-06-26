// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/dao/crypto_wallets_dao.m.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.m.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_wallets_repository.r.g.dart';

@Riverpod(keepAlive: true)
CryptoWalletsRepository cryptoWalletsRepository(Ref ref) => CryptoWalletsRepository(
      ref.watch(cryptoWalletsDaoProvider),
    );

class CryptoWalletsRepository {
  CryptoWalletsRepository(
    this._cryptoWalletsDao,
  );

  final CryptoWalletsDao _cryptoWalletsDao;

  Future<void> save({required Wallet wallet, required bool isHistoryLoaded}) async {
    if (wallet.address == null) return;

    return _cryptoWalletsDao.save([
      CryptoWallet(
        id: wallet.id,
        address: wallet.address!,
        networkId: wallet.network,
        isHistoryLoaded: isHistoryLoaded,
      ),
    ]);
  }

  /// Indicates whether the transaction history has been fully loaded into the database previously
  Future<bool> isHistoryLoadedForWallet({required String walletId}) {
    return _cryptoWalletsDao.isHistoryLoadedForWallet(id: walletId);
  }
}
