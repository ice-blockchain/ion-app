// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_network_modal/select_network_modal.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ProfileNetworkButton extends StatelessWidget {
  const ProfileNetworkButton({
    required this.pubkey,
    required this.paymentType,
    required this.onUpdate,
    super.key,
    this.coinInWallet,
  });

  final String pubkey;
  final PaymentType paymentType;
  final CoinInWalletData? coinInWallet;
  final ValueChanged<NetworkData> onUpdate;

  @override
  Widget build(BuildContext context) {
    return coinInWallet != null
        ? NetworkButton(
            network: coinInWallet!.coin.network,
            onTap: () async {
              final coin = coinInWallet!.coin;

              final network = await SelectNetworkRoute(
                pubkey: pubkey,
                paymentType: paymentType,
                coinSymbolGroup: coin.symbolGroup,
                coinAbbreviation: coin.abbreviation,
                selectNetworkModalType: SelectNetworkModalType.update,
              ).push<NetworkData?>(context);

              if (network == null) return;

              onUpdate(network);
            },
          )
        : ItemLoadingState(itemHeight: 60.0.s);
  }
}
