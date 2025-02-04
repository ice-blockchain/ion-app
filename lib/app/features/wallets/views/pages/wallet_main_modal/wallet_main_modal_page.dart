// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_main_modal/wallet_main_modal_list_item.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/main_modal_item.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class WalletMainModalPage extends StatelessWidget {
  const WalletMainModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.screen(
              title: Text(context.i18n.wallet_modal_title),
              showBackButton: false,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const HorizontalSeparator(),
              itemCount: WalletMainModalListItem.values.length,
              itemBuilder: (BuildContext context, int index) {
                final type = WalletMainModalListItem.values[index];

                final routeLocation = _getSubRouteLocation(type);
                return MainModalItem(
                  item: type,
                  onTap: () => context.pushReplacement(routeLocation),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getSubRouteLocation(WalletMainModalListItem type) {
    return switch (type) {
      WalletMainModalListItem.send => CoinSendRoute().location,
      WalletMainModalListItem.receive => ReceiveCoinRoute().location,
    };
  }
}
