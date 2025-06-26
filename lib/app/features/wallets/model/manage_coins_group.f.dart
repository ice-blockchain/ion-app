// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coins_group.f.dart';

part 'manage_coins_group.f.freezed.dart';

@freezed
class ManageCoinsGroup with _$ManageCoinsGroup {
  const factory ManageCoinsGroup({
    required CoinsGroup coinsGroup,
    required bool isSelected,
    @Default(false) bool isUpdating,
  }) = _ManageCoinsGroup;
}
