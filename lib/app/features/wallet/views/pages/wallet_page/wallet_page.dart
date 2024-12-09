// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/wallet/model/nft_layout_type.dart';
import 'package:ion/app/features/wallet/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/loaders/grid_loader.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/loaders/list_loader.dart';
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
        return coinsState.isLoading
            ? [const ListLoader()]
            : [
                const CoinsTab(),
                const CoinsTabFooter(),
              ];
      }
      if (nftsState.isLoading) {
        return nftLayoutType == NftLayoutType.list ? [const ListLoader()] : [const GridLoader()];
      }
      return [
        const NftsTab(),
        const NftsTabFooter(),
      ];
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
