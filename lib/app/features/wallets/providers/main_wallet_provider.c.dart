// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_wallet_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<Wallet?> mainWallet(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  // TODO: take the list from walletsDataNotifierProvider when connected to ionClient
  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  final wallets = await ionIdentity(username: currentIdentityKeyName).wallets.getWallets();
  final mainWallet = wallets.firstWhereOrNull((wallet) => wallet.name == 'main');
  if (mainWallet == null) {
    throw MainWalletNotFoundException();
  }

  return mainWallet;
}
