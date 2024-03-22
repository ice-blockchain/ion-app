import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_nfts.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTabFooter extends HookConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<NftData> nfts = useFilteredWalletNfts(ref);

    if (nfts.isEmpty) {
      return const EmptyState(
        tabType: tabType,
      );
    }

    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: BottomAction(
          asset: tabType.bottomActionAsset,
          title: tabType.getBottomActionTitle(context),
          onTap: () {},
        ),
      ),
    );
  }
}
