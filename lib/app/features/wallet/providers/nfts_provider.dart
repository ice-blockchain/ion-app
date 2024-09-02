import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.g.dart';

@Riverpod(keepAlive: true)
List<NftData> nftsData(NftsDataRef ref) => mockedNftsDataArray;

@riverpod
NftData nftById(NftByIdRef ref, {required int coinId}) {
  final coins = ref.watch(nftsDataProvider);

  return coins.firstWhere((NftData nft) => nft.identifier == coinId);
}
