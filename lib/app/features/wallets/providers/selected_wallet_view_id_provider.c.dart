// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/providers/storage/local_storage.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_wallet_view_id_provider.c.g.dart';

// TODO: rename to something like "SavedWalletIdNotifier"
@Riverpod(keepAlive: true)
class SelectedWalletViewIdNotifier extends _$SelectedWalletViewIdNotifier {
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
