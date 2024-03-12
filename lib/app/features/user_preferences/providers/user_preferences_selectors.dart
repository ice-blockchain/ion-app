import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user_preferences/model/user_preferences.dart';
import 'package:ice/app/features/user_preferences/providers/user_preferences_provider.dart';

bool isBalanceVisibleSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

bool isWalletValuesVisibleSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) =>
          userPreferences.isWalletValuesVisible,
    ),
  );
}
