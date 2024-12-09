// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';

part 'coin_receive_modal_data.c.freezed.dart';

@freezed
class CoinReceiveModalData with _$CoinReceiveModalData {
  const factory CoinReceiveModalData({
    required CoinData coinData,
    required NetworkType networkType,
  }) = _CoinReceiveModalData;
}
