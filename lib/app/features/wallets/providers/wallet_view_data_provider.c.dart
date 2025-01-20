// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_view_id_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_view_data_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<String> currentWalletViewId(Ref ref) async {
  final savedSelectedWalletId = ref.watch(selectedWalletViewIdNotifierProvider);
  final walletsData = await ref.watch(walletViewsDataNotifierProvider.future);

  final selectedWallet =
      walletsData.firstWhereOrNull((wallet) => wallet.id == savedSelectedWalletId);
  return selectedWallet?.id ?? walletsData.firstOrNull?.id ?? '';
}

@riverpod
Future<WalletViewData> currentWalletViewData(Ref ref) async {
  final currentWalletId = await ref.watch(currentWalletViewIdProvider.future);
  final walletsData = await ref.watch(walletViewsDataNotifierProvider.future);

  return walletsData.firstWhere((wallet) => wallet.id == currentWalletId);
}

@riverpod
Future<WalletViewData> walletViewById(Ref ref, {required String id}) async {
  final wallets = await ref.watch(walletViewsDataNotifierProvider.future);

  return wallets.firstWhere((wallet) => wallet.id == id);
}

@Riverpod(keepAlive: true)
class WalletViewsDataNotifier extends _$WalletViewsDataNotifier {
  @override
  Future<List<WalletViewData>> build() async {
    final walletViews = await ref.watch(currentUserWalletViewsProvider.future);

    // TODO: Need to watch here coins price from the repo
    return walletViews;
  }
}
