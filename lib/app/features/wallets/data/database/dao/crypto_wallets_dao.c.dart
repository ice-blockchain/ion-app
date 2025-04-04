import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/tables/crypto_wallets_table.c.dart';
import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crypto_wallets_dao.c.g.dart';

@Riverpod(keepAlive: true)
CryptoWalletsDao cryptoWalletsDao(Ref ref) =>
    CryptoWalletsDao(db: ref.watch(walletsDatabaseProvider));

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
