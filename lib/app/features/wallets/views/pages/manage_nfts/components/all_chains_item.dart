// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/view_models/nft_networks_view_model.dart';
import 'package:ion/generated/assets.gen.dart';

class AllChainsItem extends ConsumerWidget {
  const AllChainsItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(nftNetworksViewModelProvider);

    return ValueListenableBuilder(
      valueListenable: viewModel.selectedNetworkIds,
      builder: (context, selectedNetworkIds, _) {
        final isSelected = selectedNetworkIds.isEmpty;

        return ListItem(
          title: Text(context.i18n.all_chains_item),
          backgroundColor: context.theme.appColors.tertararyBackground,
          leading: IconAsset(Assets.svgWalletallnetwork, size: 40.0),
          trailing: isSelected
              ? IconAsset(Assets.svgIconBlockCheckboxOn)
              : IconAsset(Assets.svgIconBlockCheckboxOff),
          onTap: viewModel.unselectAllNetworks,
        );
      },
    );
  }
}
