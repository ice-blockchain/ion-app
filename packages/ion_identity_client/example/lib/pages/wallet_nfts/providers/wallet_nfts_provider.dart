// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_nfts_provider.g.dart';

@riverpod
Future<WalletNfts> walletNfts(Ref ref, String walletId) async {
  final username = ref.watch(currentUsernameNotifierProvider) ?? 'ERROR';

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: username).wallets.getWalletNfts(walletId);
}
