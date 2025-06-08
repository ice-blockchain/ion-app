// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/wallets/data/models/database/tables/crypto_wallets_table.c.dart';
import 'package:ion/app/features/wallets/data/models/database/wallets_database.c.dart';

part 'crypto_wallets_dao.c.g.dart';

@DriftAccessor(tables: [CryptoWalletsTable])
class CryptoWalletsDao extends DatabaseAccessor<WalletsDatabase> with _$CryptoWalletsDaoMixin {
  CryptoWalletsDao({required WalletsDatabase db}) : super(db);

  Future<void> save(List<CryptoWallet> wallets) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(cryptoWalletsTable, wallets);
    });
  }

  Future<bool> isHistoryLoadedForWallet({required String id}) async {
    final wallet =
        await (select(cryptoWalletsTable)..where((w) => w.id.equals(id))).getSingleOrNull();
    return wallet?.isHistoryLoaded ?? false;
  }
}
