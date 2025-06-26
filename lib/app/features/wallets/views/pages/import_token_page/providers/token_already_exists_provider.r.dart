// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_data_notifier_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_already_exists_provider.r.g.dart';

@riverpod
Future<bool> tokenAlreadyExists(Ref ref) async {
  final tokenData = await ref.watch(tokenDataNotifierProvider.future);
  if (tokenData == null) return false;

  final currentWalletView = await ref.read(currentWalletViewDataProvider.future);
  final walletCoins =
      currentWalletView.coinGroups.expand((e) => e.coins).map((e) => e.coin).toList();

  return walletCoins.any((coin) => coin.contractAddress == tokenData.contractAddress);
}
