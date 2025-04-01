// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_broadcasted_transfers_service.c.g.dart';

@riverpod
Future<SyncBroadcastedTransfersService> syncBroadcastedTransfersService(Ref ref) async {
  return SyncBroadcastedTransfersService(
    await ref.watch(transactionsRepositoryProvider.future),
    await ref.watch(walletsNotifierProvider.future),
  );
}

class SyncBroadcastedTransfersService {
  SyncBroadcastedTransfersService(
    this._transactionsRepository,
    this._userWallets,
  );

  final TransactionsRepository _transactionsRepository;
  final List<Wallet> _userWallets;

  // TODO: Improve it when all transactions sync with DB will be implemented
  Future<void> syncBroadcastedTransfers() async {
    final unconfirmedTransfers = await _transactionsRepository.getBroadcastedTransfers();
    if (unconfirmedTransfers.isEmpty) return;

    final updatedTransfers = await unconfirmedTransfers
        .map((transfer) {
          final wallet = _userWallets.firstWhereOrNull(
            (w) => transfer.senderWalletAddress == w.address,
          );

          if (wallet == null || transfer.id == null) return null;

          return _transactionsRepository.getCoinTransferById(
            transferId: transfer.id!,
            walletId: wallet.id,
          );
        })
        .nonNulls
        .wait
        .then((updatedTransfers) => updatedTransfers.nonNulls);
    if (updatedTransfers.isNotEmpty) {
      await _transactionsRepository.saveTransactions(updatedTransfers.toList());
    }
  }
}
