// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/should_show_friends_selector_provider.c.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/nfts_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/header/header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/loaders/grid_loader.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/loaders/list_loader.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_tab.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_tab_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final activeTab = useState<WalletTabType>(WalletTabType.coins);
    final nftsState = ref.watch(filteredNftsProvider);
    final nftLayoutType = ref.watch(nftLayoutTypeSelectorProvider);

    Widget getActiveTabContent() {
      if (activeTab.value == WalletTabType.coins) {
        return const CoinsTab();
      }
      if (nftsState.isLoading) {
        return nftLayoutType == NftLayoutType.list ? const ListLoader() : const GridLoader();
      }
      return const NftsTab();
    }

    final showFriends = ref.watch(shouldShowFriendsSelectorProvider).valueOrNull ?? true;

    return Scaffold(
      body: SafeArea(
        child: PullToRefreshBuilder(
          slivers: [
            CollapsingAppBar(
              height: FeedControls.height,
              child: const Header(),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Balance(),
                  if (showFriends) ...[
                    const Delimiter(),
                    const ContactsList(),
                  ],
                  const Delimiter(),
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
            getActiveTabContent(),
          ],
          onRefresh: () async {
            final currentUserFollowList = ref.read(currentUserFollowListProvider).valueOrNull;
            if (currentUserFollowList != null) {
              ref.read(ionConnectCacheProvider.notifier).remove(currentUserFollowList.cacheKey);
            }
            ref
              ..invalidate(walletViewsDataNotifierProvider)
              ..invalidate(coinsInWalletProvider)
              ..invalidate(nftsDataProvider);
          },
          builder: (context, slivers) => CustomScrollView(
            controller: scrollController,
            slivers: slivers,
          ),
        ),
      ),
    );
  }
}
