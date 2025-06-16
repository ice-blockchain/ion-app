// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/view_models/nft_networks_view_model.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageNftNetworkItem extends ConsumerWidget {
  const ManageNftNetworkItem({required this.network, super.key});

  final String network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(nftNetworksViewModelProvider);
    final networkData = ref.watch(networkByIdProvider(network)).valueOrNull;

    return ValueListenableBuilder(
      valueListenable: viewModel.selectedNetworkIds,
      builder: (context, selectedNetworkIds, _) {
        final isSelected = selectedNetworkIds.contains(network);

        return ListItem(
          title: Text(networkData?.displayName ?? ''),
          backgroundColor: context.theme.appColors.tertararyBackground,
          leading: NetworkIconWidget(
            size: 40.0.s,
            imageUrl: networkData?.image ?? '',
          ),
          trailing: isSelected
              ? IconAsset(Assets.svgIconBlockCheckboxOn)
              : IconAsset(Assets.svgIconBlockCheckboxOff),
          onTap: () => viewModel.toggleNetwork(network),
        );
      },
    );
  }
}
