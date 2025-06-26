// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_wallet_view_provider.r.g.dart';

@riverpod
class DeleteWalletViewNotifier extends _$DeleteWalletViewNotifier {
  @override
  FutureOr<void> build({required String walletViewId}) {}

  Future<void> delete() async {
    if (state.isLoading) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final notifier = ref.read(walletViewsDataNotifierProvider.notifier);
      await notifier.delete(walletViewId);
    });
  }
}
