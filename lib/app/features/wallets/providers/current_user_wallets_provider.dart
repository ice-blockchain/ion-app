// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_wallets_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Wallet>> currentUserWallets(Ref ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return [];
  }

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  return ionIdentity(username: currentIdentityKeyName).wallets.getWallets();
}
