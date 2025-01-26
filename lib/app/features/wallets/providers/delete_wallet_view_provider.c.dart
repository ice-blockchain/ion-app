// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
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
      final notifier = ref.read(walletViewsDataNotifierProvider.notifier);
      await notifier.delete(walletViewId);
    });
  }
}
