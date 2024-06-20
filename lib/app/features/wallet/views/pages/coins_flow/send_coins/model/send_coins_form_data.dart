import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';

part 'send_coins_form_data.freezed.dart';

@Freezed(copyWith: true)
class SendCoinsFormData with _$SendCoinsFormData {
  const factory SendCoinsFormData({
    required CoinData selectedCoin,
    required WalletData wallet,
    required NetworkType selectedNetwork,
    required String address,
    required double usdtAmount,
    required int? arrivalTime,
  }) = _SendCoinsFormData;
}
