import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';

part 'wallet_data.freezed.dart';

@Freezed(copyWith: true)
class WalletData with _$WalletData {
  const factory WalletData({
    required String id,
    required String name,
    required String icon,
    required double balance,
    required List<CoinData> coins,
    required List<NftData> nfts,
  }) = _WalletData;
}
