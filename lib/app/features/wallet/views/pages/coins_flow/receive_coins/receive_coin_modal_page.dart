import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coins_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

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
        type: CoinsListViewType.receive,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
