import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coins_list_view.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class ReceiveCoinModalPage extends IceSimplePage {
  const ReceiveCoinModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    return SheetContent(
      body: CoinsListView(
        coinTap: (CoinData coin) {
          IceRoutes.networkSelectReceive.push(
            context,
            payload: coin,
          );
        },
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
