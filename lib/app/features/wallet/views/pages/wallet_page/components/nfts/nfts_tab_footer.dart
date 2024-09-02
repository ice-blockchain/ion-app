import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/search_visibility_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTabFooter extends ConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchVisibleProvider = walletSearchVisibilityProvider(tabType);
    final isSearchVisible = ref.watch(searchVisibleProvider);

    return SliverToBoxAdapter(
      child: !isSearchVisible
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
