// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/friends_section_providers.c.dart';
import 'package:ion/app/features/wallets/domain/transactions/sync_transactions_service.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/friends/friends_list.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/friends/friends_list_loader.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/header/header.dart';
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

    final shouldShowLoader = ref.watch(shouldShowFriendsLoaderProvider);
    final showFriendsSection = ref.watch(shouldShowFriendsSectionProvider);

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
                  if (showFriendsSection) ...[
                    const Delimiter(),
                    if (shouldShowLoader)
                      FriendsListLoader(
                        footer: SizedBox(
                          height: ScreenSideOffset.defaultSmallMargin,
                        ),
                      )
                    else
                      const FriendsList(),
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

            await ref
                .read(syncTransactionsServiceProvider.future)
                .then((service) => service.sync());

            ref.invalidate(walletViewsDataNotifierProvider);
          },
          builder: (context, slivers) => CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
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
