import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/wallet_assets_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_provider.g.dart';

@Riverpod(keepAlive: true)
class NftsNotifier extends _$NftsNotifier {
  @override
  AsyncValue<List<NftData>> build() {
    return AsyncData<List<NftData>>(
      List<NftData>.unmodifiable(<NftData>[]),
    );
  }

  Future<void> fetch({
    required String walletId,
    required String searchValue,
  }) async {
    state = const AsyncLoading<List<NftData>>().copyWithPrevious(state);

    // to emulate loading state
    await Future<void>.delayed(const Duration(seconds: 1));

    final String lSearchValue = searchValue.trim().toLowerCase();
    state = AsyncData<List<NftData>>(
      List<NftData>.unmodifiable(
        mockedNftsDataArray.where(
          (NftData data) =>
              data.collectionName.toLowerCase().contains(lSearchValue),
        ),
      ),
    );
  }
}
