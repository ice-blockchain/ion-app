// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coins_list_view.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class SendCoinModalPage extends ConsumerWidget {
  const SendCoinModalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsResult = ref.watch(filteredCoinsNotifierProvider);

    return SheetContent(
      body: CoinsListView(
        coinsResult: coinsResult,
        onItemTap: (group) {
          ref.read(sendAssetFormControllerProvider.notifier).setCoin(group);
          NetworkSelectSendRoute().push<void>(context);
        },
        title: context.i18n.wallet_send_coins,
        onQueryChanged: (String query) {
          ref.read(filteredCoinsNotifierProvider.notifier).search(query);
        },
      ),
    );
  }
}
