import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/features/core/providers/permissions_provider_selectors.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/wallet/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ice/app/features/wallet/providers/selectors/wallet_assets_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ice/app/services/logger/logger.dart';

class WalletPage extends HookConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final hasContactsPermission = hasPermissionSelector(ref, PermissionType.Contacts);

    useOnInit(() {
      if (hasContactsPermission ?? false) {
        ref.read(contactsDataNotifierProvider.notifier).fetchContacts();
      } else {
        AllowAccessRoute().go(context);
      }
    }, <Object?>[
      hasContactsPermission,
    ]);

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final activeTab = useState<WalletTabType>(WalletTabType.coins);
    final isVisible = walletTabSearchVisibleSelector(ref, activeTab.value);
    final searchValue = walletAssetSearchValueSelector(ref, activeTab.value);
    final fetchedData = ref.watch(fetchCoinsDataProvider(searchValue));
    final isLoading = combinedIsLoadingSelector(ref);

    Logger.log('WalletPage - build - isVisible: $isVisible, isLoading: $isLoading');

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
          fetchedData.maybeWhen(
            orElse: () => const ListItemsLoadingState(),
            data: (data) {
              return SizedBox.shrink();
              // return [
              //   if (activeTab.value == WalletTabType.nfts)
              //     const NftsTabHeader()
              //   else
              //     const CoinsTabHeader(),
              //   if (activeTab.value == WalletTabType.coins) const CoinsTab() else const NftsTab(),
              //   if (activeTab.value == WalletTabType.coins)
              //     const CoinsTabFooter()
              //   else
              //     const NftsTabFooter(),
              // ];
            },
          ),
        ],
      ),
    );
  }
}
