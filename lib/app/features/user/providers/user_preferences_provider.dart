import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/model/user_preferences.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/services/storage/user_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_preferences_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  static String isBalanceVisibleKey = 'UserPreferences:isBalanceVisible';
  static String isZeroValueAssetsVisibleKey = 'UserPreferences:isZeroValueAssetsVisible';
  static String nftLayoutTypeKey = 'UserPreferences:nftLayoutType';
  static String nftSortingTypeKey = 'UserPreferences:nftSortingType';

  String? _userId;

  @override
  UserPreferences build() {
    final userId = ref.watch(userDataNotifierProvider.select((state) => state.id));
    _userId = userId;
    final userPreferencesService = ref.watch(userPreferencesServiceProvider(userId: userId));

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

    return UserPreferences(
      isBalanceVisible: isBalanceVisible,
      isZeroValueAssetsVisible: isZeroValueAssetsVisible,
      nftLayoutType: nftLayoutType,
      nftSortingType: nftSortingType,
    );
  }

  void switchBalanceVisibility() {
    assert(_userId != null);
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: _userId!));
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
    userPreferencesService.setValue(
      isBalanceVisibleKey,
      state.isBalanceVisible,
    );
  }

  void switchZeroValueAssetsVisibility() {
    assert(_userId != null);
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: _userId!));
    state = state.copyWith(
      isZeroValueAssetsVisible: !state.isZeroValueAssetsVisible,
    );
    userPreferencesService.setValue(
      isZeroValueAssetsVisibleKey,
      state.isZeroValueAssetsVisible,
    );
  }

  void setNftLayoutType(NftLayoutType newNftLayoutType) {
    assert(_userId != null);
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: _userId!));
    state = state.copyWith(
      nftLayoutType: newNftLayoutType,
    );
    userPreferencesService.setEnum<NftLayoutType>(
      nftLayoutTypeKey,
      newNftLayoutType,
    );
  }

  void setNftSortingType(NftSortingType newNftSortingType) {
    assert(_userId != null);
    final userPreferencesService = ref.read(userPreferencesServiceProvider(userId: _userId!));
    state = state.copyWith(
      nftSortingType: newNftSortingType,
    );
    userPreferencesService.setEnum<NftSortingType>(
      nftSortingTypeKey,
      newNftSortingType,
    );
  }
}
