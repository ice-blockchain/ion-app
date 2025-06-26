// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/model/transaction_status.f.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transfer_status_updater.r.g.dart';

@Riverpod(keepAlive: true)
Future<TransferStatusUpdater> transferStatusUpdater(Ref ref) async {
  return TransferStatusUpdater(
    await ref.watch(transactionsRepositoryProvider.future),
  );
}

///
/// [TransferStatusUpdater] updates the status of transfers in the wallet with the broadcasted status.
///
class TransferStatusUpdater {
  const TransferStatusUpdater(this._transactionsRepository);

  final TransactionsRepository _transactionsRepository;

  Future<void> update(Wallet wallet) async {
    final broadcasted = await _transactionsRepository.getBroadcastedTransfers(
      walletAddress: wallet.address,
    );
    if (broadcasted.isEmpty) return;

    final updated = <TransactionData>[];
    String? nextPageToken = '';

    try {
      while (nextPageToken != null) {
        final result = await _transactionsRepository.loadTransfers(
          wallet.id,
          pageToken: nextPageToken.isEmpty ? null : nextPageToken,
        );
        nextPageToken = result.nextPageToken;

        final filtered =
            result.items.where((e) => e.txHash != null && e.requestBody is CoinTransferRequestBody);

        for (final transfer in filtered) {
          final matching = broadcasted.firstWhereOrNull((t) => t.txHash == transfer.txHash);
          if (matching != null) {
            updated.add(
              matching.copyWith(
                status: TransactionStatus.fromJson(transfer.status),
                dateConfirmed: transfer.dateConfirmed,
              ),
            );
            broadcasted.remove(matching);
          }
        }

        if (broadcasted.isEmpty) break;
      }

      if (updated.isNotEmpty) {
        await _transactionsRepository.saveTransactions(updated);
      }
    } catch (e, stack) {
      Logger.error(
        e,
        stackTrace: stack,
        message: 'Failed to update transfers for wallet(${wallet.id})',
      );
    }
  }
}
