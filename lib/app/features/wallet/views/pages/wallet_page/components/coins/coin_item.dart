import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/utils/num.dart';

class CoinItem extends ConsumerWidget {
  const CoinItem({
    required this.coinData,
    required this.onTap,
    super.key,
  });

  final CoinData coinData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = isBalanceVisibleSelector(ref);
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
    );
  }
}
