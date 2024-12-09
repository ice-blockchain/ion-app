// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/model/nft_layout_type.dart';
import 'package:ion/app/features/wallet/providers/filtered_wallet_nfts_provider.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/constants.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/nft_grid_item.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/nft_list_item.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NftsTab extends ConsumerWidget {
  const NftsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  static const double aspectRatio = 0.72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nfts = ref.watch(filteredWalletNftsProvider).valueOrNull ?? [];
    final nftLayoutType = ref.watch(nftLayoutTypeSelectorProvider);

    if (nfts.isEmpty) {
      return const EmptyState(
        tabType: tabType,
      );
    }

    if (nftLayoutType == NftLayoutType.grid) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: NftConstants.gridSpacing,
            mainAxisSpacing: NftConstants.gridSpacing,
            childAspectRatio: aspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return NftGridItem(
                nftData: nfts[index],
              );
            },
            childCount: nfts.length,
          ),
        ),
      );
    }

    return nfts.isNotEmpty
        ? SliverList.separated(
            itemCount: nfts.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12.0.s,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ScreenSideOffset.small(
                child: NftListItem(
                  nftData: nfts[index],
                  onTap: () {
                    NftDetailsRoute($extra: nfts[index]).push<void>(context);
                  },
                ),
              );
            },
          )
        : const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
