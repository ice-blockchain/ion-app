import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';

part 'receive_coins_form_data.freezed.dart';

@Freezed(copyWith: true)
class ReceiveCoinsFormData with _$ReceiveCoinsFormData {
  const factory ReceiveCoinsFormData({
    required CoinData selectedCoin,
    required NetworkType selectedNetwork,
    required String address,
  }) = _ReceiveCoinsFormData;
}
