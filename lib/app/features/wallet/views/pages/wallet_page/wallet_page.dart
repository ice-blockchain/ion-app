import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/wallet/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ice/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_nfts.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab_footer.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final hasContactsPermission = ref.watch(hasPermissionSelectorProvider(PermissionType.Contacts));

    useOnInit(() {
      if (hasContactsPermission) {
        ref.read(contactsDataNotifierProvider.notifier).fetchContacts();
      } else {
        AllowAccessRoute().go(context);
      }
    }, <Object?>[
      hasContactsPermission,
    ]);

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final activeTab = useState<WalletTabType>(WalletTabType.coins);
    final coinsResult = useFilteredWalletCoins(ref);
    final nftsResult = useFilteredWalletNfts(ref);

    final isLoading = coinsResult.isLoading || nftsResult.isLoading;

    List<Widget> getActiveTabContent() {
      if (isLoading) {
        return [const ListItemsLoadingState()];
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
