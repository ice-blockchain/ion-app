import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/services/storage/local_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  static String isBalanceVisibleKey = 'UserPreferences:isBalanceVisible';
  static String isZeroValueAssetsVisibleKey = 'UserPreferences:isZeroValueAssetsVisible';
  static String nftLayoutTypeKey = 'UserPreferences:nftLayoutType';
  static String nftSortingTypeKey = 'UserPreferences:nftSortingType';

  @override
  UserPreferences build() {
    final localStorage = ref.watch(localStorageProvider);
    final isBalanceVisible = localStorage.getBool(isBalanceVisibleKey, defaultValue: true);
    final isZeroValueAssetsVisible =
        localStorage.getBool(isZeroValueAssetsVisibleKey, defaultValue: true);
    final nftLayoutType = localStorage.getEnum<NftLayoutType>(
      nftLayoutTypeKey,
      NftLayoutType.values,
      defaultValue: NftLayoutType.list,
    );
    final nftSortingType = localStorage.getEnum<NftSortingType>(
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
    final localStorage = ref.read(localStorageProvider);
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
    localStorage.setBool(
      key: isBalanceVisibleKey,
      value: state.isBalanceVisible,
    );
  }

  void switchZeroValueAssetsVisibility() {
    final localStorage = ref.read(localStorageProvider);
    state = state.copyWith(
      isZeroValueAssetsVisible: !state.isZeroValueAssetsVisible,
    );
    localStorage.setBool(
      key: isZeroValueAssetsVisibleKey,
      value: state.isZeroValueAssetsVisible,
    );
  }

  void setNftLayoutType(NftLayoutType newNftLayoutType) {
    final localStorage = ref.read(localStorageProvider);
    state = state.copyWith(
      nftLayoutType: newNftLayoutType,
    );
    localStorage.setEnum<NftLayoutType>(
      nftLayoutTypeKey,
      newNftLayoutType,
    );
  }

  void setNftSortingType(NftSortingType newNftSortingType) {
    final localStorage = ref.read(localStorageProvider);
    state = state.copyWith(
      nftSortingType: newNftSortingType,
    );
    localStorage.setEnum<NftSortingType>(
      nftSortingTypeKey,
      newNftSortingType,
    );
  }
}
