// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/current_user_wallet_views_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_view_provider.c.g.dart';

@riverpod
class CreateWalletViewNotifier extends _$CreateWalletViewNotifier {
  @override
  Future<void> build() async {
    state = const AsyncData(null);
  }

  Future<void> createWalletView({
    required String name,
  }) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final identity = await ref.read(ionIdentityClientProvider.future);
      await identity.wallets.createWalletView(
        CreateUpdateWalletViewRequest(items: [], symbolGroups: [], name: name),
      );

      ref.invalidate(currentUserWalletViewsProvider);
    });
  }
}
