// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.f.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';

part 'coin_receive_modal_data.f.freezed.dart';

@freezed
class CoinReceiveModalData with _$CoinReceiveModalData {
  const factory CoinReceiveModalData({
    required CoinData coinData,
    required NetworkData network,
  }) = _CoinReceiveModalData;
}
