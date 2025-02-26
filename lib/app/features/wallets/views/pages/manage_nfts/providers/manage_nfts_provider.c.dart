// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/model/manage_nft_network_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_nfts_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ManageNftNetworksNotifier extends _$ManageNftNetworksNotifier {
  @override
  AsyncValue<Set<ManageNftNetworkData>> build() {
    // TODO: Not implemented
    return const AsyncData<Set<ManageNftNetworkData>>({});
  }

  void selectNetwork({
    required bool isSelected,
    required NetworkData network,
  }) {
    final currentSet = state.value ?? {};

    // TODO: All Networks item is not implemented
    if (isSelected && currentSet.any((nftNetworkData) => !nftNetworkData.isSelected)) {
      return;
    }

    final updatedNftsNetworksSet = currentSet.map((nftNetworkData) {
      if (nftNetworkData.network == network) {
        return nftNetworkData.copyWith(isSelected: !isSelected);
      }

      return nftNetworkData;
    }).toSet();
    // TODO: Recheck logic when All Networks item is implemented
    // final updatedNftsNetworksSet = networkType == NetworkType.all
    //     ? currentSet.map((nftNetworkData) {
    //         if (nftNetworkData.networkType == NetworkType.all) {
    //           return nftNetworkData.copyWith(isSelected: !isSelected);
    //         }
    //         return nftNetworkData.copyWith(isSelected: false);
    //       }).toSet()
    //     : currentSet.map((nftNetworkData) {
    //         if (nftNetworkData.networkType == NetworkType.all) {
    //           return nftNetworkData.copyWith(isSelected: false);
    //         } else if (nftNetworkData.networkType == networkType) {
    //           return nftNetworkData.copyWith(isSelected: !isSelected);
    //         }
    //
    //         return nftNetworkData;
    //       }).toSet();

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
              (network) =>
                  network.network.displayName.toLowerCase().contains(query) ||
                  network.network.id.toLowerCase().contains(query),
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
