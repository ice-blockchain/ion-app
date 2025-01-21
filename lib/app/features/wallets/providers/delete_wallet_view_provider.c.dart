// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_wallet_view_provider.c.g.dart';

@riverpod
class DeleteWalletViewNotifier extends _$DeleteWalletViewNotifier {
  @override
  Future<void> build() async {
    state = const AsyncData(null);
  }

  Future<void> delete({required String walletViewId}) async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final identity = await ref.read(ionIdentityClientProvider.future);
      await identity.wallets.deleteWalletView(walletViewId);

      ref.invalidate(currentUserWalletViewsProvider);
    });
  }
}
