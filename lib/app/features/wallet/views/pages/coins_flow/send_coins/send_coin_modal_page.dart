import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coins_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/my_app_routes.dart';

class SendCoinModalPage extends MyIcePage {
  const SendCoinModalPage({super.key});

  // const SendCoinModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: CoinsListView(
        onCoinItemTap: (CoinData coin) {
          ref.read(sendCoinsFormControllerProvider.notifier).selectCoin(coin);
          const NetworkSelectRoute().push<void>(context);
          // IceRoutes.networkSelect.push(
          //   context,
          // );
        },
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
