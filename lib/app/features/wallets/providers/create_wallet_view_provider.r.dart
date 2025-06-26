// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_view_provider.r.g.dart';

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
      final notifier = ref.read(walletViewsDataNotifierProvider.notifier);
      await notifier.create(name);
    });
  }
}
