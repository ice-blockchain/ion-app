import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_wallet_id_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectedWalletIdNotifier extends _$SelectedWalletIdNotifier {
  static String selectedWalletIdKey = 'UserPreferences:selectedWalletId';

  @override
  String? build() {
    return LocalStorage.getString(selectedWalletIdKey);
  }

  set selectedWalletId(String selectedWalletId) {
    state = selectedWalletId;
    LocalStorage.setString(selectedWalletIdKey, selectedWalletId);
  }
}
