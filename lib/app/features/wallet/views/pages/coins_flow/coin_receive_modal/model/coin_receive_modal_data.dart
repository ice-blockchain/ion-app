import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';

part 'coin_receive_modal_data.freezed.dart';

@Freezed(copyWith: true)
class CoinReceiveModalData with _$CoinReceiveModalData {
  const factory CoinReceiveModalData({
    required CoinData coinData,
    required NetworkType networkType,
  }) = _CoinReceiveModalData;
}
