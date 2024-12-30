// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/components/coin_icon_with_network/coin_icon_with_network.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/utils/num.dart';

class NetworkItem extends ConsumerWidget {
  const NetworkItem({
    required this.networkType,
    required this.coinData,
    required this.onTap,
    super.key,
  });

  final NetworkType networkType;
  final CoinData coinData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);

    return ListItem(
      title: Row(
        children: [
          Text(coinData.name),
          SizedBox(width: 5.0.s),
          _NetworkLabel(network: networkType),
        ],
      ),
      subtitle: Text(coinData.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: CoinIconWithNetwork.small(
        coinData,
        network: networkType,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isBalanceVisible ? coinData.amount.toString() : '****',
            style: context.theme.appTextThemes.body
                .copyWith(color: context.theme.appColors.primaryText),
          ),
          Text(
            isBalanceVisible ? formatToCurrency(coinData.balance) : '******',
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

  final NetworkType network;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0.s),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        color: context.theme.appColors.attentionBlock,
      ),
      child: Text(
        network.getDisplayName(context),
        style: context.theme.appTextThemes.caption3.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
    );
  }
}
