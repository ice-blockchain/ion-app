// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network.dart';

part 'manage_nft_network_data.c.freezed.dart';

@freezed
class ManageNftNetworkData with _$ManageNftNetworkData {
  const factory ManageNftNetworkData({
    required bool isSelected,
    required Network network,
  }) = _ManageNftNetworkData;
}
