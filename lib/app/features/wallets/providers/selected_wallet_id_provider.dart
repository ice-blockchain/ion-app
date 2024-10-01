// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_wallet_id_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectedWalletIdNotifier extends _$SelectedWalletIdNotifier {
  static String selectedWalletIdKey = 'UserPreferences:selectedWalletId';

  @override
  String? build() {
    return ref.watch(localStorageProvider).getString(selectedWalletIdKey) ??
        mockedWalletDataArray.first.id;
  }

  set selectedWalletId(String selectedWalletId) {
    state = selectedWalletId;
    ref.read(localStorageProvider).setString(selectedWalletIdKey, selectedWalletId);
  }
}
