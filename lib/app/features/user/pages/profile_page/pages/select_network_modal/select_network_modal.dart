// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/wallet/components/coin_networks_list/coin_networks_list_view.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum SelectNetworkModalType {
  select,
  update,
}

class SelectNetworkModal extends StatelessWidget {
  const SelectNetworkModal({
    required this.pubkey,
    required this.type,
    required this.coinId,
    required this.paymentType,
    super.key,
  });

  final String pubkey;
  final SelectNetworkModalType type;
  final String coinId;
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: CoinNetworksListView(
        onItemTap: (NetworkType networkType) {
          switch (type) {
            case SelectNetworkModalType.select:
              switch (paymentType) {
                case PaymentType.send:
                  SendCoinsFormRoute(
                    pubkey: pubkey,
                    coinId: coinId,
                    networkType: networkType,
                  ).go(context);
                case PaymentType.receive:
                  RequestCoinsFormRoute(
                    pubkey: pubkey,
                    coinId: coinId,
                    networkType: networkType,
                  ).go(context);
              }
            case SelectNetworkModalType.update:
              context.pop(networkType);
          }
        },
        coinId: coinId,
        title: context.i18n.wallet_choose_network,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
