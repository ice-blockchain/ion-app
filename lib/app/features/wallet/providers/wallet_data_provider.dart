import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data.dart';
import 'package:ice/app/features/wallet/model/wallet_data_with_loading_state.dart';
import 'package:ice/app/features/wallet/providers/wallet_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_data_provider.g.dart';

@Riverpod(keepAlive: true)
class WalletDataNotifier extends _$WalletDataNotifier {
  @override
  WalletDataWithLoadingState build() {
    return WalletDataWithLoadingState(
      walletData: mockedWalletDataArray[0],
      loadingAssets: <WalletAssetType, AsyncValue<bool>>{},
      assetSearchValues: <WalletAssetType, String>{},
    );
  }

  set walletData(WalletData newData) {
    state = state.copyWith(
      walletData: newData,
      loadingAssets: <WalletAssetType, AsyncValue<bool>>{},
      assetSearchValues: <WalletAssetType, String>{},
    );
  }

  WalletData _filterCoinsByName({required String searchValue}) {
    final String lSearchValue = searchValue.toLowerCase();
    return state.walletData.copyWith(
      coins: mockedWalletDataArray[0]
          .coins
          .where(
            (CoinData coinData) =>
                coinData.name.toLowerCase().contains(lSearchValue),
          )
          .toList(),
    );
  }

  WalletData _filterNftsByName({required String searchValue}) {
    final String lSearchValue = searchValue.toLowerCase();
    return state.walletData.copyWith(
      nfts: mockedWalletDataArray[0]
          .nfts
          .where(
            (NftData nftData) =>
                nftData.collectionName.toLowerCase().contains(lSearchValue),
          )
          .toList(),
    );
  }

  Map<WalletAssetType, AsyncValue<bool>> _updateLoadingAssets({
    required AsyncValue<bool> newState,
    required WalletAssetType assetType,
  }) {
    return Map<WalletAssetType, AsyncValue<bool>>.from(state.loadingAssets)
      ..update(
        assetType,
        (_) => newState,
        ifAbsent: () => newState,
      );
  }

  Future<void> _filterAssetsByName({
    required String searchValue,
    required WalletAssetType assetType,
  }) async {
    state = state.copyWith(
      loadingAssets: _updateLoadingAssets(
        newState: const AsyncValue<bool>.loading(),
        assetType: assetType,
      ),
    );
    try {
      // to emulate loading state
      await Future<void>.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        walletData: switch (assetType) {
          WalletAssetType.coin => _filterCoinsByName(searchValue: searchValue),
          WalletAssetType.nft => _filterNftsByName(searchValue: searchValue),
        },
        loadingAssets: _updateLoadingAssets(
          newState: const AsyncValue<bool>.data(true),
          assetType: assetType,
        ),
      );
    } catch (e, stackTrace) {
      state = state.copyWith(
        walletData: switch (assetType) {
          WalletAssetType.coin => _filterCoinsByName(searchValue: searchValue),
          WalletAssetType.nft => _filterNftsByName(searchValue: searchValue),
        },
        loadingAssets: _updateLoadingAssets(
          newState: AsyncValue<bool>.error(e, stackTrace),
          assetType: assetType,
        ),
      );
    }
  }

  void updateSearchValue({
    required String searchValue,
    required WalletAssetType assetType,
  }) {
    final String? currentSearchValue = state.assetSearchValues[assetType];
    state = state.copyWith(
      assetSearchValues:
          Map<WalletAssetType, String>.from(state.assetSearchValues)
            ..update(
              assetType,
              (_) => searchValue,
              ifAbsent: () => searchValue,
            ),
    );
    if (currentSearchValue != searchValue) {
      _filterAssetsByName(searchValue: searchValue, assetType: assetType);
    }
  }
}
