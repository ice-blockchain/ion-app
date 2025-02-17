// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';

part 'coin_receive_modal_data.c.freezed.dart';

@freezed
class CoinReceiveModalData with _$CoinReceiveModalData {
  const factory CoinReceiveModalData({
    required CoinData coinData,
    required Network network,
  }) = _CoinReceiveModalData;
}
