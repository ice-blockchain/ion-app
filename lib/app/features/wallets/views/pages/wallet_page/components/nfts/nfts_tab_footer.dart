// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/core/data/models/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/constants.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/providers/search_visibility_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';

class NftsTabFooter extends ConsumerWidget {
  const NftsTabFooter({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.nfts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchVisibleProvider = walletSearchVisibilityProvider(tabType);
    final isSearchVisible = ref.watch(searchVisibleProvider);
    final buyNftFeatureEnabled =
        ref.watch(featureFlagsProvider.notifier).get(WalletFeatureFlag.buyNftEnabled);

    return SliverToBoxAdapter(
      child: buyNftFeatureEnabled && !isSearchVisible
          ? ScreenSideOffset.small(
              child: BottomAction(
                asset: tabType.bottomActionAsset,
                title: tabType.getBottomActionTitle(context),
                onTap: () {},
              ),
            )
          : SizedBox(height: NftConstants.gridSpacing),
    );
  }
}
