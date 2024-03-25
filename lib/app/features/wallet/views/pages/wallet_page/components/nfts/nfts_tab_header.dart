import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_nfts.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_header_layout_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_header_sort_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/search_bar/search_bar.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTabHeader extends HookConsumerWidget {
  const NftsTabHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NftData> nfts = useFilteredWalletNfts(ref);

    if (nfts.isEmpty) {
      return SliverToBoxAdapter(
        child: ScreenSideOffset.small(
          child: WalletSearchBar(
            padding: EdgeInsets.only(top: UiConstants.hitSlop),
            tabType: WalletTabType.nfts,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 16.0.s - UiConstants.hitSlop,
          left: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
          right: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
        ),
        child: Column(
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                NftHeaderSortAction(),
                Spacer(),
                NftHeaderLayoutAction(),
              ],
            ),
            WalletSearchBar(
              padding: EdgeInsets.only(
                left: UiConstants.hitSlop,
                right: UiConstants.hitSlop,
                top: 16.0.s - UiConstants.hitSlop,
                bottom: UiConstants.hitSlop,
              ),
              tabType: WalletTabType.nfts,
            ),
          ],
        ),
      ),
    );
  }
}
