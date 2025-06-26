// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_tab.dart';

class GridLoader extends ConsumerWidget {
  const GridLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyNftFeatureEnabled =
        ref.watch(featureFlagsProvider.notifier).get(WalletFeatureFlag.buyNftEnabled);

    final width =
        (MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2 - 12.0.s) / 2;
    final height = width / NftsTab.aspectRatio;
    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            Row(
              children: [
                ContainerSkeleton(width: width, height: height),
                SizedBox(
                  width: 12.0.s,
                ),
                ContainerSkeleton(width: width, height: height),
              ],
            ),
            if (buyNftFeatureEnabled) ...[
              SizedBox(
                height: 16.0.s,
              ),
              ItemLoadingState(
                itemHeight: 60.0.s,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
