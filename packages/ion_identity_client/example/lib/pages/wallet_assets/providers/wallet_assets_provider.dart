// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/current_username_notifier.dart';
import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_assets_provider.g.dart';

@riverpod
Future<WalletAssets> walletAssets(WalletAssetsRef ref, String walletId) async {
  final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';
  final ionClient = await ref.watch(ionClientProvider.future);

  return ionClient(username: username).wallets.getWalletAssets(walletId);
}
