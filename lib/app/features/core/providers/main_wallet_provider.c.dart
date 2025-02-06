// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_wallet_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<Wallet> mainWallet(Ref ref) async {
  final wallets = await ref.watch(walletsNotifierProvider.future);
  final mainWallet = wallets.firstWhereOrNull((wallet) => wallet.name == 'main');

  if (mainWallet == null) {
    throw MainWalletNotFoundException();
  }

  return mainWallet;
}
