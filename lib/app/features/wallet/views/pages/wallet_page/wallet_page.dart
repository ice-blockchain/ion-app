import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/core/providers/permissions_provider_selectors.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/header/header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/nfts/nfts_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';

class WalletPage extends IceSimplePage {
  const WalletPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ScrollController scrollController = useScrollController();
    final bool? hasContactsPermission = hasContactsPermissionSelector(ref);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasContactsPermission == true) {
            ref.read(contactsDataNotifierProvider.notifier).fetchContacts();
          } else {
            IceRoutes.allowAccess.go(context);
          }
        });
        return null;
      },
      <Object?>[
        hasContactsPermission,
      ],
    );

    final ValueNotifier<WalletTabType> activeTab =
        useState<WalletTabType>(WalletTabType.coins);
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          FloatingAppBar(
            height: FeedControls.height,
            child: const Header(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Balance(),
                const ContactsList(),
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
          if (activeTab.value == WalletTabType.coins)
            const CoinsTab()
          else
            const NftsTab(),
        ],
      ),
    );
  }
}
