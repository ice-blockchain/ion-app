import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/dtos/wallet_asset_dto.dart';

part 'wallet_assets_dto.freezed.dart';
part 'wallet_assets_dto.g.dart';

@freezed
class WalletAssetsDto with _$WalletAssetsDto {
  factory WalletAssetsDto({
    required String walletId,
    required String network,
    required List<WalletAssetDto> assets,
  }) = _WalletAssetsDto;

  factory WalletAssetsDto.fromJson(JsonObject json) => _$WalletAssetsDtoFromJson(json);
}
