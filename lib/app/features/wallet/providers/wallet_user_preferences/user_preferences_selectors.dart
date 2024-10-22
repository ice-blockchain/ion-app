// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/wallet/model/nft_layout_type.dart';
import 'package:ion/app/features/wallet/model/nft_sorting_type.dart';
import 'package:ion/app/features/wallet/model/user_preferences.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_selectors.g.dart';

@riverpod
bool isBalanceVisibleSelector(Ref ref) {
  final userId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isBalanceVisible,
    ),
  );
}

@riverpod
bool isZeroValueAssetsVisibleSelector(Ref ref) {
  final userId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.isZeroValueAssetsVisible,
    ),
  );
}

@riverpod
NftLayoutType nftLayoutTypeSelector(Ref ref) {
  final userId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftLayoutType,
    ),
  );
}

@riverpod
NftSortingType nftSortingTypeSelector(Ref ref) {
  final userId = ref.watch(currentIdentityKeyNameSelectorProvider) ?? '';

  return ref.watch(
    walletUserPreferencesNotifierProvider(userId: userId).select(
      (UserPreferences userPreferences) => userPreferences.nftSortingType,
    ),
  );
}
