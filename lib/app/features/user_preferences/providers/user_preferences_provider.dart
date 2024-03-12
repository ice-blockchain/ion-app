import 'package:ice/app/features/user_preferences/model/user_preferences.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  static String isBalanceVisibleKey = 'UserPreferences:isBalanceVisible';
  static String isWalletValuesVisibleKey =
      'UserPreferences:isWalletValuesVisible';

  @override
  UserPreferences build() {
    final bool isBalanceVisible =
        LocalStorage.getBool(isBalanceVisibleKey, defaultValue: true);
    final bool isWalletValuesVisible =
        LocalStorage.getBool(isWalletValuesVisibleKey, defaultValue: true);

    return UserPreferences(
      isBalanceVisible: isBalanceVisible,
      isWalletValuesVisible: isWalletValuesVisible,
    );
  }

  void switchBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
    LocalStorage.setBool(isBalanceVisibleKey, state.isBalanceVisible);
  }

  void switchWalletValuesVisibility() {
    state = state.copyWith(isWalletValuesVisible: !state.isWalletValuesVisible);
    LocalStorage.setBool(isWalletValuesVisibleKey, state.isWalletValuesVisible);
  }
}
