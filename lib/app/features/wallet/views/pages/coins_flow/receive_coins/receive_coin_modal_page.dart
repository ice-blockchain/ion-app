// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/components/coins_list/coins_list_view.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ReceiveCoinModalPage extends ConsumerWidget {
  const ReceiveCoinModalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(receiveCoinsFormControllerProvider);
    return SheetContent(
      body: CoinsListView(
        onCoinItemTap: (CoinData coin) {
          ref.read(receiveCoinsFormControllerProvider.notifier).setCoin(coin);
          NetworkSelectReceiveRoute().push<void>(context);
        },
        title: context.i18n.wallet_receive_coins,
        showBackButton: true,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
