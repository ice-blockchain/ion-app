// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/balance_display_order.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';
import 'package:ion/app/features/wallets/model/nft_sorting_type.dart';
import 'package:ion/app/features/wallets/model/user_preferences.f.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_user_preferences_provider.r.g.dart';

@Riverpod(keepAlive: true)
class WalletUserPreferencesNotifier extends _$WalletUserPreferencesNotifier {
  static String isBalanceVisibleKey = 'UserPreferences:isBalanceVisible';
  static String isZeroValueAssetsVisibleKey = 'UserPreferences:isZeroValueAssetsVisible';
  static String nftLayoutTypeKey = 'UserPreferences:nftLayoutType';
  static String nftSortingTypeKey = 'UserPreferences:nftSortingType';
  static String balanceDisplayOrderKey = 'UserPreference:balanceDisplayOrder';

  @override
  UserPreferences build({required String identityKeyName}) {
    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));

    final isBalanceVisible = userPreferencesService.getValue<bool>(isBalanceVisibleKey) ?? true;

    final isZeroValueAssetsVisible =
        userPreferencesService.getValue<bool>(isZeroValueAssetsVisibleKey) ?? true;

    final nftLayoutType = userPreferencesService.getEnum<NftLayoutType>(
          nftLayoutTypeKey,
          NftLayoutType.values,
        ) ??
        NftLayoutType.list;

    final nftSortingType = userPreferencesService.getEnum<NftSortingType>(
          nftSortingTypeKey,
          NftSortingType.values,
        ) ??
        NftSortingType.desc;

    final balanceDisplayOrder = userPreferencesService.getEnum<BalanceDisplayOrder>(
          balanceDisplayOrderKey,
          BalanceDisplayOrder.values,
        ) ??
        BalanceDisplayOrder.coinUsd;

    return UserPreferences(
      isBalanceVisible: isBalanceVisible,
      isZeroValueAssetsVisible: isZeroValueAssetsVisible,
      nftLayoutType: nftLayoutType,
      nftSortingType: nftSortingType,
      balanceDisplayOrder: balanceDisplayOrder,
    );
  }

  void switchBalanceVisibility() {
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
    userPreferencesService.setValue(
      isBalanceVisibleKey,
      state.isBalanceVisible,
    );
  }

  void switchZeroValueAssetsVisibility() {
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    state = state.copyWith(
      isZeroValueAssetsVisible: !state.isZeroValueAssetsVisible,
    );
    userPreferencesService.setValue(
      isZeroValueAssetsVisibleKey,
      state.isZeroValueAssetsVisible,
    );
  }

  void setNftLayoutType(NftLayoutType newNftLayoutType) {
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    state = state.copyWith(
      nftLayoutType: newNftLayoutType,
    );
    userPreferencesService.setEnum<NftLayoutType>(
      nftLayoutTypeKey,
      newNftLayoutType,
    );
  }

  void setNftSortingType(NftSortingType newNftSortingType) {
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    state = state.copyWith(
      nftSortingType: newNftSortingType,
    );
    userPreferencesService.setEnum<NftSortingType>(
      nftSortingTypeKey,
      newNftSortingType,
    );
  }

  void switchBalanceDisplayOrder() {
    final userPreferencesService =
        ref.read(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    state = state.copyWith(
      balanceDisplayOrder: state.balanceDisplayOrder.toggled,
    );
    userPreferencesService.setEnum<BalanceDisplayOrder>(
      balanceDisplayOrderKey,
      state.balanceDisplayOrder,
    );
  }
}
