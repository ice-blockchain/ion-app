import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';

part 'crypto_asset_data.freezed.dart';

@Freezed(copyWith: true)
class CryptoAssetData with _$CryptoAssetData {
  const factory CryptoAssetData({
    required WalletData wallet,
    required NetworkType selectedNetwork,
    required int arrivalTime,
    required String address,
    CoinData? selectedCoin,
    NftData? selectedNft,
    double? usdtAmount,
    ContactData? selectedContact,
  }) = _CryptoAssetData;
}
