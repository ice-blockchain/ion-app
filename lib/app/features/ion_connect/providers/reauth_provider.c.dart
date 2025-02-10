// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/main_wallet_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/active_relays_provider.c.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reauth_provider.c.g.dart';

@riverpod
Future<(UserDelegationEntity?, Set<String>)> reauth(Ref ref) async {
  final mainWallet = await ref.read(mainWalletProvider.future);
  final delegation =
      await ref.watch(cachedUserDelegationProvider(mainWallet.signingKey.publicKey).future);

  final relays = ref.watch(activeRelaysProvider);

  return (delegation, relays);
}
