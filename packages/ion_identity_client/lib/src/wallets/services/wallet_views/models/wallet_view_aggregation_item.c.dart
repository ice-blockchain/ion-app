// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/network/number_to_string_converter.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/models/wallet_view_aggregation_wallet.c.dart';

part 'wallet_view_aggregation_item.c.freezed.dart';
part 'wallet_view_aggregation_item.c.g.dart';

@freezed
class WalletViewAggregationItem with _$WalletViewAggregationItem {
  const factory WalletViewAggregationItem({
    @JsonKey(defaultValue: []) required List<WalletViewAggregationWallet> wallets,
    @NumberToStringConverter() required String totalBalance,
  }) = _WalletViewAggregationItem;

  factory WalletViewAggregationItem.fromJson(Map<String, dynamic> json) =>
      _$WalletViewAggregationItemFromJson(json);
}
