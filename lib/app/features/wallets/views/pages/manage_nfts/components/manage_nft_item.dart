// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/pages/manage_nfts/providers/manage_nfts_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageNftNetworkItem extends ConsumerWidget {
  const ManageNftNetworkItem({required this.networkType, super.key});

  final NetworkData networkType;

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
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: NetworkIconWidget(
        size: 40.0.s,
        imageUrl: networkType.image,
      ),
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
