// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';

part 'manage_nft_network_data.freezed.dart';

@freezed
class ManageNftNetworkData with _$ManageNftNetworkData {
  const factory ManageNftNetworkData({
    required bool isSelected,
    required NetworkType networkType,
  }) = _ManageNftNetworkData;
}
