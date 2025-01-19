// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_view_provider.c.g.dart';

@riverpod
Future<void> createWalletView(Ref ref, {required String walletViewName}) async {
  final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return;
  }

  final ionIdentity = await ref.read(ionIdentityProvider.future);
  final identity = ionIdentity(username: currentIdentityKeyName);

  await identity.wallets.createWalletView(
    CreateUpdateWalletViewRequest(items: [], symbolGroups: [], name: walletViewName),
  );

  ref.invalidate(currentUserWalletViewsProvider);
}
