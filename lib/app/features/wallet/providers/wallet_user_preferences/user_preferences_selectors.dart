import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/wallet/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/model/nft_sorting_type.dart';
import 'package:ice/app/features/wallet/model/user_preferences.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_selectors.g.dart';

@riverpod
bool isBalanceVisibleSelector(IsBalanceVisibleSelectorRef ref) {
  final userId = ref.watch(currentUserIdSelectorProvider);

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

@riverpod
bool isZeroValueAssetsVisibleSelector(IsZeroValueAssetsVisibleSelectorRef ref) {
  final userId = ref.watch(currentUserIdSelectorProvider);

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isZeroValueAssetsVisible,
    ),
  );
}

@riverpod
NftLayoutType nftLayoutTypeSelector(NftLayoutTypeSelectorRef ref) {
  final userId = ref.watch(currentUserIdSelectorProvider);

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftLayoutType,
    ),
  );
}

@riverpod
NftSortingType nftSortingTypeSelector(NftSortingTypeSelectorRef ref) {
  final userId = ref.watch(currentUserIdSelectorProvider);

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftSortingType,
    ),
  );
}
