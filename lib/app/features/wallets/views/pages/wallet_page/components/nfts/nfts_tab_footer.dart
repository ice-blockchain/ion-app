// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class NftsTabFooter extends ConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: BottomAction(
          asset: tabType.bottomActionAsset,
          title: tabType.getBottomActionTitle(context),
          onTap: () async {
            await SelectNetworkToReceiveNftRoute().push<void>(ref.context);
          },
        ),
      ),
    );
  }
}
