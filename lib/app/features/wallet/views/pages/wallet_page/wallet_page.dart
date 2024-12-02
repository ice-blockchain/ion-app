// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/wallet/model/nft_layout_type.dart';
import 'package:ion/app/features/wallet/providers/filtered_assets_provider.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab_footer.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab_header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final activeTab = useState<WalletTabType>(WalletTabType.coins);
    final coinsState = ref.watch(filteredCoinsProvider);
    final nftsState = ref.watch(filteredNftsProvider);
    final nftLayoutType = ref.watch(nftLayoutTypeSelectorProvider);

    List<Widget> getActiveTabContent() {
      if (activeTab.value == WalletTabType.coins) {
        if (coinsState.isLoading) {
          return [const _ListLoader()];
        }
        return [
          const CoinsTab(),
          const CoinsTabFooter(),
        ];
      } else {
        if (nftsState.isLoading) {
          if (nftLayoutType == NftLayoutType.list) {
            return [const _ListLoader()];
          }
          return [const _GridLoader()];
        }
        return [
          const NftsTab(),
          const NftsTabFooter(),
        ];
      }
    }

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          CollapsingAppBar(
            height: FeedControls.height,
            child: const Header(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Balance(),
                const ContactsList(),
                Delimiter(
                  padding: EdgeInsets.only(
                    top: 16.0.s,
                  ),
                ),
                WalletTabsHeader(
                  activeTab: activeTab.value,
                  onTabSwitch: (WalletTabType newTab) {
                    if (newTab != activeTab.value) {
                      activeTab.value = newTab;
                    }
                  },
                ),
              ],
            ),
          ),
          if (activeTab.value == WalletTabType.nfts)
            const NftsTabHeader()
          else
            const CoinsTabHeader(),
          ...getActiveTabContent(),
        ],
      ),
    );
  }
}

class _ListLoader extends StatelessWidget {
  const _ListLoader();

  @override
  Widget build(BuildContext context) {
    return ListItemsLoadingState(
      itemsCount: 7,
      separatorHeight: 12.0.s,
      itemHeight: 60.0.s,
      padding: EdgeInsets.zero,
      listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
    );
  }
}

class _GridLoader extends StatelessWidget {
  const _GridLoader();

  @override
  Widget build(BuildContext context) {
    final width =
        (MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2 - 12.0.s) / 2;
    final height = width / NftsTab.aspectRatio;
    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            Row(
              children: [
                ContainerSkeleton(width: width, height: height),
                SizedBox(
                  width: 12.0.s,
                ),
                ContainerSkeleton(width: width, height: height),
              ],
            ),
            SizedBox(
              height: 16.0.s,
            ),
            ItemLoadingState(
              itemHeight: 60.0.s,
            ),
          ],
        ),
      ),
    );
  }
}
