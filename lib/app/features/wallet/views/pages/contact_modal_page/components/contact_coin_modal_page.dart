import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/components/coins_list_view.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_state.dart';
import 'package:ice/app/features/wallet/views/pages/send_funds_result_page/model/transaction_type.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class ContactCoinModalPage extends IcePage {
  const ContactCoinModalPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: CoinsListView(
        onCoinItemTap: (CoinData coin) {
          SendFundsResultRoute(
            $extra: SuccessContactTransactionState(
              TransactionType.coinTransaction,
              coin,
            ), //TODO: get data from network
          ).push<void>(context);
        },
      ),
    );
  }
}
