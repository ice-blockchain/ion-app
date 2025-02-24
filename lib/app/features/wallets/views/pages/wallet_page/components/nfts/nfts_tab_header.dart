// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_header_layout_action.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_header_select_action.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/search_bar/search_bar.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/view_models/wallet_nfts_view_model.dart';

class NftsTabHeader extends ConsumerWidget {
  const NftsTabHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftsViewModel = ref.watch(walletNftsViewModelProvider);

    return ValueListenableBuilder(
      valueListenable: nftsViewModel.loadNftsCommand.isExecuting,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return ScreenSideOffset.small(
            child: WalletSearchBar(
              padding: EdgeInsets.only(top: UiConstants.hitSlop),
              tabType: WalletTabType.nfts,
            ),
          );
        }

        return ValueListenableBuilder(
          valueListenable: nftsViewModel.filteredNfts,
          builder: (context, nfts, _) {
            if (nfts.isEmpty) {
              return ScreenSideOffset.small(
                child: WalletSearchBar(
                  padding: EdgeInsets.only(top: UiConstants.hitSlop),
                  tabType: WalletTabType.nfts,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: 16.0.s - UiConstants.hitSlop,
                left: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
                right: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: NftHeaderSelectAction()),
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
            );
          },
        );
      },
    );
  }
}
