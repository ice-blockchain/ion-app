// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class CoinButton extends StatelessWidget {
  const CoinButton({
    required this.coinInWallet,
    required this.onTap,
    super.key,
  });

  final CoinInWalletData coinInWallet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.strokeElements),
        borderRadius: BorderRadius.circular(16.0.s),
        color: colors.secondaryBackground,
      ),
      child: ListItem(
        contentPadding: EdgeInsets.only(
          left: ScreenSideOffset.defaultSmallMargin,
          right: 8.0.s,
        ),
        title: Text(
          coinInWallet.coin.name,
          style: textTheme.body,
        ),
        subtitle: Text(
          coinInWallet.coin.abbreviation,
          style: textTheme.caption3,
        ),
        backgroundColor: Colors.transparent,
        leading: CoinIconWidget(
          imageUrl: coinInWallet.coin.iconUrl,
          size: 36.0.s,
        ),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatCrypto(coinInWallet.amount),
                  style: textTheme.body,
                ),
                Text(
                  formatToCurrency(coinInWallet.balanceUSD),
                  style: textTheme.caption3.copyWith(
                    color: colors.secondaryText,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(8.0.s),
                child: Assets.svg.iconArrowDown.icon(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
