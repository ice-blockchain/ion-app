import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'wallet_asset_dto.freezed.dart';
part 'wallet_asset_dto.g.dart';

@freezed
class WalletAssetDto with _$WalletAssetDto {
  factory WalletAssetDto({
    required String? name,
    required String? contract,
    required String symbol,
    required int decimals,
    required String balance,
    required bool verified,
  }) = _WalletAssetDto;

  factory WalletAssetDto.fromJson(JsonObject json) => _$WalletAssetDtoFromJson(json);
}
