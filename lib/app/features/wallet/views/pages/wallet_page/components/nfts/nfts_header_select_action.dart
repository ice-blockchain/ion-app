// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/model/manage_nft_network_data.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/providers/manage_nfts_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class NftHeaderSelectAction extends ConsumerWidget {
  const NftHeaderSelectAction({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNftNetworks = ref.watch(selectedNftsNetworksProvider).value;
    final color = context.theme.appColors.secondaryText;

    String joinSelectedNetworks() {
      if (selectedNftNetworks == null) {
        return '';
      }

      return selectedNftNetworks.any(
        (ManageNftNetworkData network) => network.networkType == NetworkType.all,
      )
          ? context.i18n.core_all
          : selectedNftNetworks.map((e) => e.networkType.name.toUpperCase()).join(', ');
    }

    return TextButton(
      onPressed: () {
        ManageNftsRoute().go(context);
      },
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Row(
          children: [
            Flexible(
              child: Text(
                '${context.i18n.core_chain}: ${joinSelectedNetworks()}',
                style: context.theme.appTextThemes.caption.copyWith(color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 5.0.s,
            ),
            Assets.svg.iconArrowDown.icon(size: 20.0.s, color: color),
          ],
        ),
      ),
    );
  }
}