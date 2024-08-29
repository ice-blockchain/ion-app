import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTabFooter extends ConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = walletTabSearchVisibleSelector(ref, tabType);

    return SliverToBoxAdapter(
      child: !isVisible
          ? ScreenSideOffset.small(
              child: BottomAction(
                asset: tabType.bottomActionAsset,
                title: tabType.getBottomActionTitle(context),
                onTap: () {},
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
