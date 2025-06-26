// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/providers/search_coins_notifier_provider.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.r.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coins_list_view.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.r.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ReceiveCoinModalPage extends HookConsumerWidget {
  const ReceiveCoinModalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(receiveCoinsFormControllerProvider);

    final searchText = useState('');
    final searchCoinsNotifier = ref.watch(searchCoinsNotifierProvider.notifier);
    final searchResult = ref.watch(searchCoinsNotifierProvider);
    final walletCoins = ref.watch(currentWalletViewDataProvider).requireValue.coinGroups;

    useOnInit(
      () => searchCoinsNotifier.search(query: searchText.value),
      [searchText.value],
    );

    return SheetContent(
      body: CoinsListView(
        onQueryChanged: (String value) => searchText.value = value,
        coinsResult: searchText.value.isEmpty ? AsyncData(walletCoins) : searchResult,
        onItemTap: (group) {
          ref.read(receiveCoinsFormControllerProvider.notifier).setCoin(group);
          NetworkSelectReceiveRoute().push<void>(context);
        },
        title: context.i18n.wallet_receive_coins,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
