// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_view_item.f.freezed.dart';
part 'wallet_view_item.f.g.dart';

@freezed
class WalletViewItem with _$WalletViewItem {
  const factory WalletViewItem({
    required String coinId,
    String? walletId,
  }) = _WalletViewItem;

  factory WalletViewItem.fromJson(Map<String, dynamic> json) => _$WalletViewItemFromJson(json);
}
