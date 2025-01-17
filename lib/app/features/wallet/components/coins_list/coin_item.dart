// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/utils/num.dart';

class CoinItem extends ConsumerWidget {
  const CoinItem({
    required this.coinInWallet,
    required this.onTap,
    super.key,
  });

  final CoinInWalletData coinInWallet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);
    final coinData = coinInWallet.coin;

    return ListItem(
      title: Text(coinData.name),
      subtitle: Text(coinData.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: coinData.iconUrl.icon(size: 36.0.s),
      onTap: onTap,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isBalanceVisible ? coinInWallet.amount.toString() : '****',
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
    );
  }
}
