import 'package:freezed_annotation/freezed_annotation.dart';

part 'coin_data.freezed.dart';

@Freezed(copyWith: true)
class CoinData with _$CoinData {
  const factory CoinData({
    required String abbreviation,
    required String name,
    required double amount,
    required double balance,
    required String iconUrl,
  }) = _CoinData;
}
