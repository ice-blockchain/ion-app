// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_id_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_data_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<String> currentWalletId(Ref ref) async {
  final savedSelectedWalletId = ref.watch(selectedWalletIdNotifierProvider);
  final walletsData = await ref.watch(walletsDataNotifierProvider.future);

  // TODO(Denis): Not implemented
  final selectedWallet = walletsData
      .firstWhereOrNull((wallet) => wallet.id == savedSelectedWalletId);
  return selectedWallet?.id ?? walletsData.firstOrNull?.id ?? '';
  // return '';
}

@riverpod
Future<WalletViewData> currentWalletData(Ref ref) async {
  final currentWalletId = await ref.watch(currentWalletIdProvider.future);
  final walletsData = await ref.watch(walletsDataNotifierProvider.future);

  // TODO(Denis): Not implemented
  // return walletsData.firstWhere((wallet) => wallet.id == currentWalletId);
  return walletsData.first;
}

@riverpod
Future<WalletViewData> walletById(Ref ref, {required String id}) async {
  final wallets = await ref.watch(walletsDataNotifierProvider.future);

  // TODO(Denis): Not implemented
  // return wallets.firstWhere((wallet) => wallet.id == id);
  return wallets.first;
}

@Riverpod(keepAlive: true)
class WalletsDataNotifier extends _$WalletsDataNotifier {
  @override
  Future<List<WalletViewData>> build() async {
    final walletViews = await ref.watch(currentUserWalletsProvider.future);
WalletView
    return [
      WalletViewData(
        id: 'test id',
        name: 'main',
        icon: 'NULL',
        balance: 0,
        address: 'empty',
      ),
    ];
    // return walletViews.map((walletView){
    //   return WalletData(
    //     id: walletView.name,
    //     name: walletView.name,
    //     icon: 'NULL',
    //     balance: 0,
    //     address: walletView.address,
    //   );
    // }).toList();
    // return walletViews;
  }
}
