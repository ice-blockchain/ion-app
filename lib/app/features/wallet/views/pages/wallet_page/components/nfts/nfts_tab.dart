import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_nfts.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/constants.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nft_grid_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nft_list_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTab extends HookConsumerWidget {
  const NftsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NftData> nfts = useFilteredWalletNfts(ref);
    final NftLayoutType nftLayoutType = nftLayoutTypeSelector(ref);

    if (nfts.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
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
            childAspectRatio: 0.72,
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

    return SliverList.separated(
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
          ),
        );
      },
    );
  }
}
