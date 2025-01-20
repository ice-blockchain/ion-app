// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/providers/manage_nfts_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageNftNetworkItem extends ConsumerWidget {
  const ManageNftNetworkItem({required this.networkType, super.key});

  final NetworkType networkType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftNetworkData = ref.watch(
      manageNftNetworksNotifierProvider.select(
        (state) => state.valueOrNull?.firstWhere(
          (element) => element.networkType == networkType,
        ),
      ),
    );

    return ListItem(
      title: Text(networkType.getDisplayName(context)),
      subtitle: Text(networkType.name.toUpperCase()),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: networkType.iconAsset.icon(size: 40),
      trailing: nftNetworkData!.isSelected
          ? Assets.svg.iconBlockCheckboxOn.icon()
          : Assets.svg.iconBlockCheckboxOff.icon(),
      onTap: () {
        ref.read(manageNftNetworksNotifierProvider.notifier).selectNetwork(
              networkType: networkType,
              isSelected: nftNetworkData.isSelected,
            );
      },
    );
  }
}
