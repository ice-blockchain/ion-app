// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_wallet_id_provider.g.dart';

// TODO: rename to something like "SavedWalletIdNotifier"
@Riverpod(keepAlive: true)
class SelectedWalletIdNotifier extends _$SelectedWalletIdNotifier {
  static String selectedWalletIdKey = 'UserPreferences:selectedWalletId';

  @override
  String? build() {
    return ref.watch(localStorageProvider).getString(selectedWalletIdKey);
  }

  set selectedWalletId(String selectedWalletId) {
    state = selectedWalletId;
    ref.read(localStorageProvider).setString(selectedWalletIdKey, selectedWalletId);
  }
}
