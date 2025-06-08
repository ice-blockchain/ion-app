// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/models/balance_display_order.dart';
import 'package:ion/app/features/wallets/data/models/nft_layout_type.dart';
import 'package:ion/app/features/wallets/data/models/nft_sorting_type.dart';

part 'user_preferences.c.freezed.dart';

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required bool isBalanceVisible,
    required bool isZeroValueAssetsVisible,
    required NftLayoutType nftLayoutType,
    required NftSortingType nftSortingType,
    required BalanceDisplayOrder balanceDisplayOrder,
  }) = _UserPreferences;
}
