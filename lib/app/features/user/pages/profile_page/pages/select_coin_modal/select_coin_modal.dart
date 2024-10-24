// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_network_modal/select_network_modal.dart';
import 'package:ion/app/features/wallet/components/coins_list/coins_list_view.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum SelectCoinModalType {
  select,
  update,
}

class SelectCoinModal extends StatelessWidget {
  const SelectCoinModal({
    required this.pubkey,
    required this.type,
    required this.paymentType,
    super.key,
  });

  final String pubkey;
  final SelectCoinModalType type;
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: CoinsListView(
        onCoinItemTap: (CoinData coinData) {
          switch (type) {
            case SelectCoinModalType.select:
              SelectNetworkRoute(
                paymentType: paymentType,
                pubkey: pubkey,
                coinId: coinData.abbreviation,
                selectNetworkModalType: SelectNetworkModalType.select,
              ).go(context);
            case SelectCoinModalType.update:
              context.pop(coinData.abbreviation);
          }
        },
        title: context.i18n.common_select_coin,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
