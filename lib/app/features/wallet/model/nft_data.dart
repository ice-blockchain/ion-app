import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_data.freezed.dart';

@Freezed(copyWith: true)
class NftData with _$NftData {
  const factory NftData({
    required String collectionName,
    required int identifier,
    required double price,
    required String currency,
    required String iconUrl,
    required String currencyIconUrl,
  }) = _NftData;
}
