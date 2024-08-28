import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.g.dart';

@Riverpod(keepAlive: true)
List<NftData> nftsData(NftsDataRef ref) => mockedNftsDataArray;

@Riverpod(keepAlive: true)
class NftsNotifier extends _$NftsNotifier {
  @override
  Future<List<NftData>> build() async {
    // Simulate a delay or fetch operation
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Fetch the search value
    final searchValue = ref.watch(walletPageNotifierProvider).assetSearchValues[WalletTabType.nfts];

    // Filter data based on search value if provided
    if (searchValue != null && searchValue.isNotEmpty) {
      final lSearchValue = searchValue.trim().toLowerCase();
      final filteredData = mockedNftsDataArray
          .where(
            (NftData data) => data.collectionName.toLowerCase().contains(lSearchValue),
          )
          .toList();

      // Return the filtered data
      return List<NftData>.unmodifiable(filteredData);
    }

    // If no search value, return the full list
    return ref.watch(nftsDataProvider);
  }
}
