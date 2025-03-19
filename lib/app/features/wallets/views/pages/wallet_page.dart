// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/should_show_friends_selector_provider.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/header/header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_tab.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/nfts/nfts_tab_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/view_models/wallet_nfts_view_model.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    useScrollTopOnTabPress(context, scrollController: scrollController);

    final activeTab = useState<WalletTabType>(WalletTabType.coins);

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
              const SliverToBoxAdapter(
                child: NftsTabHeader(),
              )
            else
              const CoinsTabHeader(),
            _ActiveTabContent(activeTab: activeTab.value),
          ],
          onRefresh: () async {
            final currentUserFollowList = ref.read(currentUserFollowListProvider).valueOrNull;
            if (currentUserFollowList != null) {
              ref.read(ionConnectCacheProvider.notifier).remove(currentUserFollowList.cacheKey);
            }
            ref
              ..invalidate(walletViewsDataNotifierProvider)
              ..invalidate(coinsInWalletProvider);

            ref.read(walletNftsViewModelProvider).loadNftsCommand();
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

class _ActiveTabContent extends StatelessWidget {
  const _ActiveTabContent({
    required this.activeTab,
  });

  final WalletTabType activeTab;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      WalletTabType.coins => const CoinsTab(),
      WalletTabType.nfts => const NftsTab(),
    };
  }
}
