// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_wallet_view_provider.c.g.dart';

@riverpod
class DeleteWalletViewNotifier extends _$DeleteWalletViewNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> delete({required String walletViewId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    final currentIdentityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      final identity = ionIdentity(username: currentIdentityKeyName);

      await identity.wallets.deleteWalletView(walletViewId);

      // ref.invalidate(currentUserWalletViewsProvider);
    });
  }
}
