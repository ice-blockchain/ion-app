import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_selectors.g.dart';

@riverpod
bool isBalanceVisibleSelector(IsBalanceVisibleSelectorRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

@riverpod
bool isZeroValueAssetsVisibleSelector(IsZeroValueAssetsVisibleSelectorRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isZeroValueAssetsVisible,
    ),
  );
}

@riverpod
NftLayoutType nftLayoutTypeSelector(NftLayoutTypeSelectorRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftLayoutType,
    ),
  );
}

@riverpod
NftSortingType nftSortingTypeSelector(NftSortingTypeSelectorRef ref) {
  final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftSortingType,
    ),
  );
}