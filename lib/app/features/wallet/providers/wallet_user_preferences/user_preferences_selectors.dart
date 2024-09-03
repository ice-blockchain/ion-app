import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';

bool isBalanceVisibleSelector(WidgetRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

bool isZeroValueAssetsVisibleSelector(WidgetRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isZeroValueAssetsVisible,
    ),
  );
}

NftLayoutType nftLayoutTypeSelector(WidgetRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftLayoutType,
    ),
  );
}

NftSortingType nftSortingTypeSelector(WidgetRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftSortingType,
    ),
  );
}
