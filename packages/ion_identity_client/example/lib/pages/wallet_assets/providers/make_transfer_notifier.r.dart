// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'make_transfer_notifier.r.g.dart';

@riverpod
class MakeTransferNotifier extends _$MakeTransferNotifier {
  @override
  FutureOr<void> build() {}

  Future<Map<String, dynamic>> makeTransfer(
    String walletId,
    String destinationAddress,
    String amount,
    WalletAsset asset,
  ) async {
    final currentUser = ref.read(currentUsernameNotifierProvider)!;
    final ion = await ref.read(ionIdentityProvider.future);

    final wallets = await ion(username: currentUser).wallets.getWallets();
    final wallet = wallets.firstWhere((wallet) => wallet.id == walletId);

    final formattedAmount = (double.parse(amount) * pow(10, asset.decimals)).toInt();

    return await ion(username: currentUser).wallets.broadcastTransaction(
          wallet,
          destinationAddress,
          "$formattedAmount",
        );
  }
}
