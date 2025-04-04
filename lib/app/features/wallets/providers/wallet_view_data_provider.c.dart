// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/wallet_views/wallet_views_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/features/wallets/providers/selected_wallet_view_id_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_initializer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_view_data_provider.c.g.dart';

@Riverpod(keepAlive: true)
class WalletViewsDataNotifier extends _$WalletViewsDataNotifier {
  StreamSubscription<List<WalletViewData>>? _subscription;

  @override
  Future<List<WalletViewData>> build() async {
    // Wait until all preparations are completed
    await ref.watch(walletsInitializerProvider.future);

    final walletViewsService = await ref.watch(walletViewsServiceProvider.future);

    final walletViews = await walletViewsService.fetch();
    walletViewsService.walletViews.listen((walletViews) {
      state = AsyncData(walletViews);
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return walletViews;
  }

  Future<void> create(String walletViewName) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.create(walletViewName);
  }

  Future<void> delete(String walletViewId) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.delete(walletViewId: walletViewId);
  }

  Future<void> updateWalletView({
    required WalletViewData walletView,
    String? updatedName,
    List<CoinData>? updatedCoinsList,
  }) async {
    final walletViewsService = await ref.read(walletViewsServiceProvider.future);
    await walletViewsService.update(
      walletView: walletView,
      updatedName: updatedName,
      updatedCoinsList: updatedCoinsList,
    );
  }
}

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
