// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/wallet_data.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallets_provider.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<String> currentWalletId(Ref ref) async {
  final savedSelectedWalletId = ref.watch(selectedWalletIdNotifierProvider);
  final walletsData = await ref.watch(walletsDataNotifierProvider.future);

  final selectedWallet =
      walletsData.firstWhereOrNull((wallet) => wallet.id == savedSelectedWalletId);
  return selectedWallet?.id ?? walletsData.firstOrNull?.id ?? '';
}

@riverpod
Future<WalletData> currentWalletData(Ref ref) async {
  final currentWalletId = await ref.watch(currentWalletIdProvider.future);
  final walletsData = await ref.watch(walletsDataNotifierProvider.future);

  return walletsData.firstWhere((wallet) => wallet.id == currentWalletId);
}

@riverpod
Future<WalletData> walletById(Ref ref, {required String id}) async {
  final wallets = await ref.watch(walletsDataNotifierProvider.future);

  return wallets.firstWhere((wallet) => wallet.id == id);
}

@Riverpod(keepAlive: true)
class WalletsDataNotifier extends _$WalletsDataNotifier {
  @override
  Future<List<WalletData>> build() async {
    final wallets = await ref.watch(currentUserWalletsProvider.future);

    return [
      for (final (_, wallet) in wallets.indexed)
        WalletData(
          id: wallet.id,
          name: wallet.name,
          icon: 'NULL',
          balance: -100,
        ),
    ];
  }
}
