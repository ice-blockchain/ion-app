// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/views/components/coin_icon_with_network.dart';
import 'package:ion/app/utils/num.dart';

class NetworkItem extends ConsumerWidget {
  const NetworkItem({
    required this.network,
    required this.coinInWallet,
    required this.onTap,
    super.key,
  });

  final Network network;
  final VoidCallback onTap;
  final CoinInWalletData coinInWallet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);

    return ListItem(
      title: Row(
        children: [
          Expanded(
            child: Text(
              coinInWallet.coin.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 5.0.s),
          _NetworkLabel(network: network),
        ],
      ),
      subtitle: Text(coinInWallet.coin.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: CoinIconWithNetwork.small(
        coinInWallet.coin.iconUrl,
        network: network,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isBalanceVisible ? formatDouble(coinInWallet.amount) : '****',
            style: context.theme.appTextThemes.body
                .copyWith(color: context.theme.appColors.primaryText),
          ),
          Text(
            isBalanceVisible ? formatToCurrency(coinInWallet.balanceUSD) : '******',
            style: context.theme.appTextThemes.caption3
                .copyWith(color: context.theme.appColors.secondaryText),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _NetworkLabel extends StatelessWidget {
  const _NetworkLabel({required this.network});

  final Network network;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: context.theme.appColors.attentionBlock,
      ),
      child: Text(
        network.displayName,
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
    );
  }
}
