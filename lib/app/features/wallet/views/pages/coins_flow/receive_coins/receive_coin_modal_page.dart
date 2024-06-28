import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coins_list_view.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/router/my_app_routes.dart';

class ReceiveCoinModalPage extends MyIcePage {
  const ReceiveCoinModalPage({super.key});

  // const ReceiveCoinModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: CoinsListView(
        onCoinItemTap: (CoinData coin) {
          // IceRoutes.networkSelectReceive.push(
          //   context,
          //   payload: coin,
          // );

          NetworkSelectReceiveRoute($extra: coin).push<void>(context);
        },
        type: CoinsListViewType.receive,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
