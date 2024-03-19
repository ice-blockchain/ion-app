import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_provider.dart';

List<CoinData> walletCoinsSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletData walletData) => walletData.coins,
    ),
  );
}

List<NftData> walletNftsSelector(WidgetRef ref) {
  return ref.watch(
    walletDataNotifierProvider.select(
      (WalletData walletData) => walletData.nfts,
    ),
  );
}
