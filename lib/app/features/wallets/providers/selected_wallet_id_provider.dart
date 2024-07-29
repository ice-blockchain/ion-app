import 'dart:async';

import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_wallet_id_provider.g.dart';

@riverpod
class SelectedWalletIdNotifier extends _$SelectedWalletIdNotifier {
  static String selectedWalletIdKey = 'UserPreferences:selectedWalletId';

  @override
  String build() {
    final localStorage = ref.watch(localStorageProvider);
    final walletsRepository = ref.watch(walletsRepositoryProvider);

    return localStorage.getString(selectedWalletIdKey) ?? walletsRepository.wallets.first.id;
  }

  void updateWalletId(String id) {
    final localStorage = ref.read(localStorageProvider);
    unawaited(localStorage.setString(selectedWalletIdKey, id));

    state = id;
  }
}
