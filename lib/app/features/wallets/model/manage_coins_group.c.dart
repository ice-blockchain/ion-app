// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';

part 'manage_coins_group.c.freezed.dart';

@freezed
class ManageCoinsGroup with _$ManageCoinsGroup {
  const factory ManageCoinsGroup({
    required CoinsGroup coinsGroup,
    required bool isSelected,
    required bool isUpdating,
  }) = _ManageCoinsGroup;
}
