// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_wallets_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Wallet>> currentUserWallets(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return [];
  }

  final ionClient = await ref.watch(ionApiClientProvider.future);

  return ionClient(username: currentIdentityKeyName).wallets.getWallets();
}
