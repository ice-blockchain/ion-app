import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';

part 'form_data.freezed.dart';

@Freezed(copyWith: true)
class FormData with _$FormData {
  const factory FormData({
    required CoinData selectedCoin,
    required NetworkType selectedNetwork,
    required String address,
    required double usdtAmount,
    required int? arrivalTime,
  }) = _FormData;
}
