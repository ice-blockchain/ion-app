import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/features/user/providers/user_preferences_provider.dart';

bool isBalanceVisibleSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

bool isZeroValueAssetsVisibleSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) =>
          userPreferences.isZeroValueAssetsVisible,
    ),
  );
}

NftLayoutType nftLayoutTypeSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) => userPreferences.nftLayoutType,
    ),
  );
}

NftSortingType nftSortingTypeSelector(WidgetRef ref) {
  return ref.watch(
    userPreferencesNotifierProvider.select(
      (UserPreferences userPreferences) => userPreferences.nftSortingType,
    ),
  );
}
