// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/wallet/providers/filtered_wallet_coins_provider.dart';
import 'package:ion/app/features/wallet/providers/filtered_wallet_nfts_provider.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_header.dart';
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
    final coinsState = ref.watch(filteredWalletCoinsProvider);
    final nftsState = ref.watch(filteredWalletNftsProvider);

    final isLoading = coinsState.isLoading || nftsState.isLoading;

    List<Widget> getActiveTabContent() {
      if (isLoading) {
        return [
          ListItemsLoadingState(
            itemsCount: 7,
            separatorHeight: 12.0.s,
            listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
          ),
        ];
      }

      if (activeTab.value == WalletTabType.coins) {
        return [
          const CoinsTab(),
          const CoinsTabFooter(),
        ];
      } else {
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
