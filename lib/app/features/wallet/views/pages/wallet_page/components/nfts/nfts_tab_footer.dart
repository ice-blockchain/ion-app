// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class NftsTabFooter extends ConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );

    // TODO: Uncomment when user will be allowed to buy NFT
    // final searchVisibleProvider = walletSearchVisibilityProvider(tabType);
    // final isSearchVisible = ref.watch(searchVisibleProvider);
    //
    // return SliverToBoxAdapter(
    //   child: !isSearchVisible
    //       ? ScreenSideOffset.small(
    //           child: BottomAction(
    //             asset: tabType.bottomActionAsset,
    //             title: tabType.getBottomActionTitle(context),
    //             onTap: () {},
    //           ),
    //         )
    //       : const SizedBox.shrink(),
    // );
  }
}
