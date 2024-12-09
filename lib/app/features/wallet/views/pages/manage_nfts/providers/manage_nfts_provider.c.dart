// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/model/manage_nft_network_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/providers/mock_data/manage_nfts_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_nfts_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ManageNftNetworksNotifier extends _$ManageNftNetworksNotifier {
  @override
  AsyncValue<Set<ManageNftNetworkData>> build() {
    return AsyncData<Set<ManageNftNetworkData>>(mockedManageNftsNetworkDataSet);
  }

  void selectNetwork({
    required bool isSelected,
    required NetworkType networkType,
  }) {
    final currentSet = state.value ?? {};

    if (networkType == NetworkType.all &&
        isSelected &&
        currentSet.any((nftNetworkData) => !nftNetworkData.isSelected)) {
      return;
    }

    final updatedNftsNetworksSet = networkType == NetworkType.all
        ? currentSet.map((nftNetworkData) {
            if (nftNetworkData.networkType == NetworkType.all) {
              return nftNetworkData.copyWith(isSelected: !isSelected);
            }
            return nftNetworkData.copyWith(isSelected: false);
          }).toSet()
        : currentSet.map((nftNetworkData) {
            if (nftNetworkData.networkType == NetworkType.all) {
              return nftNetworkData.copyWith(isSelected: false);
            } else if (nftNetworkData.networkType == networkType) {
              return nftNetworkData.copyWith(isSelected: !isSelected);
            }

            return nftNetworkData;
          }).toSet();

    state = AsyncData<Set<ManageNftNetworkData>>(updatedNftsNetworksSet);
  }
}

@Riverpod(keepAlive: true)
class FilteredNftsNetworkNotifier extends _$FilteredNftsNetworkNotifier {
  @override
  AsyncValue<Set<ManageNftNetworkData>> build({required String searchText}) {
    return const AsyncLoading();
  }

  Future<void> filter({required String searchText}) async {
    state = const AsyncLoading();

    await Future<void>.delayed(const Duration(seconds: 1));

    final allNftNetworksState = ref.read(manageNftNetworksNotifierProvider);

    state = allNftNetworksState.maybeWhen(
      data: (allNftNetworksSet) {
        final allNetworks = Set<ManageNftNetworkData>.from(allNftNetworksSet);
        final query = searchText.trim().toLowerCase();

        if (query.isEmpty) {
          return AsyncData(allNetworks);
        }

        final filteredNetworks = allNetworks
            .where(
              (network) => network.networkType.name.toLowerCase().contains(query),
            )
            .toSet();

        return AsyncData(filteredNetworks);
      },
      orElse: () => const AsyncLoading(),
    );
  }
}

@Riverpod(keepAlive: true)
AsyncValue<List<ManageNftNetworkData>> selectedNftsNetworks(Ref ref) {
  final allNftNetworksMap = ref.watch(manageNftNetworksNotifierProvider).value ?? {};
  final selected = allNftNetworksMap.where((network) => network.isSelected).toList();
  return AsyncData<List<ManageNftNetworkData>>(selected);
}
