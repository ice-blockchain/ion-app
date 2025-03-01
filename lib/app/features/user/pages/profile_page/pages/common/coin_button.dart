// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_coin_modal/select_coin_modal.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_button.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ProfileCoinButton extends StatelessWidget {
  const ProfileCoinButton({
    required this.pubkey,
    required this.paymentType,
    required this.onUpdate,
    super.key,
    this.coinInWalletData,
  });

  final String pubkey;
  final PaymentType paymentType;
  final CoinInWalletData? coinInWalletData;
  final void Function(CoinsGroup) onUpdate;

  @override
  Widget build(BuildContext context) {
    return coinInWalletData != null
        ? CoinButton(
            coinInWallet: coinInWalletData!,
            onTap: () async {
              final newCoinsGroup = await SelectCoinRoute(
                paymentType: paymentType,
                pubkey: pubkey,
                selectCoinModalType: SelectCoinModalType.update,
              ).push<CoinsGroup?>(context);

              if (newCoinsGroup != null) onUpdate(newCoinsGroup);
            },
          )
        : ItemLoadingState(itemHeight: 60.0.s);
  }
}
