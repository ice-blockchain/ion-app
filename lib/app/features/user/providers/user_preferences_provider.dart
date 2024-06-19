import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  static String isBalanceVisibleKey = 'UserPreferences:isBalanceVisible';
  static String isZeroValueAssetsVisibleKey =
      'UserPreferences:isZeroValueAssetsVisible';
  static String nftLayoutTypeKey = 'UserPreferences:nftLayoutType';
  static String nftSortingTypeKey = 'UserPreferences:nftSortingType';

  @override
  UserPreferences build() {
    final isBalanceVisible =
        LocalStorage.getBool(isBalanceVisibleKey, defaultValue: true);
    final isZeroValueAssetsVisible =
        LocalStorage.getBool(isZeroValueAssetsVisibleKey, defaultValue: true);
    final nftLayoutType = LocalStorage.getEnum<NftLayoutType>(
      nftLayoutTypeKey,
      NftLayoutType.values,
      defaultValue: NftLayoutType.list,
    );
    final nftSortingType = LocalStorage.getEnum<NftSortingType>(
      nftSortingTypeKey,
      NftSortingType.values,
      defaultValue: NftSortingType.desc,
    );

    return UserPreferences(
      isBalanceVisible: isBalanceVisible,
      isZeroValueAssetsVisible: isZeroValueAssetsVisible,
      nftLayoutType: nftLayoutType,
      nftSortingType: nftSortingType,
    );
  }

  void switchBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
    LocalStorage.setBool(
      key: isBalanceVisibleKey,
      value: state.isBalanceVisible,
    );
  }

  void switchZeroValueAssetsVisibility() {
    state = state.copyWith(
      isZeroValueAssetsVisible: !state.isZeroValueAssetsVisible,
    );
    LocalStorage.setBool(
      key: isZeroValueAssetsVisibleKey,
      value: state.isZeroValueAssetsVisible,
    );
  }

  void setNftLayoutType(NftLayoutType newNftLayoutType) {
    state = state.copyWith(
      nftLayoutType: newNftLayoutType,
    );
    LocalStorage.setEnum<NftLayoutType>(
      nftLayoutTypeKey,
      newNftLayoutType,
    );
  }

  void setNftSortingType(NftSortingType newNftSortingType) {
    state = state.copyWith(
      nftSortingType: newNftSortingType,
    );
    LocalStorage.setEnum<NftSortingType>(
      nftSortingTypeKey,
      newNftSortingType,
    );
  }
}
