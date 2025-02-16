// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/providers/manage_nfts_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageNftNetworkItem extends ConsumerWidget {
  const ManageNftNetworkItem({required this.networkType, super.key});

  final Network networkType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftNetworkData = ref.watch(
      manageNftNetworksNotifierProvider.select(
        (state) => state.valueOrNull?.firstWhere(
          (element) => element.network == networkType,
        ),
      ),
    );

    return ListItem(
      title: Text(networkType.displayName),
      subtitle: Text(networkType.displayName),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: networkType.svgIconAsset.icon(size: 40),
      trailing: nftNetworkData!.isSelected
          ? Assets.svg.iconBlockCheckboxOn.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
      onTap: () {
        ref.read(manageNftNetworksNotifierProvider.notifier).selectNetwork(
              network: networkType,
              isSelected: nftNetworkData.isSelected,
            );
      },
    );
  }
}
