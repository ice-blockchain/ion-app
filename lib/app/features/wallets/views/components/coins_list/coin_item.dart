// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/models/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class CoinsGroupItem extends ConsumerWidget {
  const CoinsGroupItem({
    required this.coinsGroup,
    required this.onTap,
    super.key,
  });

  final CoinsGroup coinsGroup;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);

    return ListItem(
      title: Text(coinsGroup.name),
      subtitle: Text(coinsGroup.abbreviation),
      backgroundColor: context.theme.appColors.tertararyBackground,
      leading: CoinIconWidget.big(coinsGroup.iconUrl),
      onTap: onTap,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            isBalanceVisible ? formatDouble(coinsGroup.totalAmount) : '****',
            style: context.theme.appTextThemes.body
                .copyWith(color: context.theme.appColors.primaryText),
          ),
          Text(
            isBalanceVisible ? formatToCurrency(coinsGroup.totalBalanceUSD) : '******',
            style: context.theme.appTextThemes.caption3
                .copyWith(color: context.theme.appColors.secondaryText),
          ),
        ],
      ),
    );
  }
}

class CoinsGroupItemPlaceholder extends StatelessWidget {
  const CoinsGroupItemPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Container(
        height: 16.0.s,
        width: 101.0.s,
        decoration: BoxDecoration(
          color: context.theme.appColors.onTerararyFill,
          borderRadius: BorderRadius.circular(8.0.s),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.0.s),
          Container(
            height: 12.0.s,
            width: 55.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.onTerararyFill,
              borderRadius: BorderRadius.circular(8.0.s),
            ),
          ),
        ],
      ),
      leading: Assets.svg.walletemptyicon2.icon(size: 36.0.s),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 16.0.s,
            width: 40.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.onTerararyFill,
              borderRadius: BorderRadius.circular(8.0.s),
            ),
          ),
          SizedBox(height: 6.0.s),
          Container(
            height: 12.0.s,
            width: 30.0.s,
            decoration: BoxDecoration(
              color: context.theme.appColors.onTerararyFill,
              borderRadius: BorderRadius.circular(8.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
