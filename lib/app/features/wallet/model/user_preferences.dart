// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/model/nft_sorting_type.dart';

part 'user_preferences.freezed.dart';

@Freezed(copyWith: true)
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required bool isBalanceVisible,
    required bool isZeroValueAssetsVisible,
    required NftLayoutType nftLayoutType,
    required NftSortingType nftSortingType,
  }) = _UserPreferences;
}
