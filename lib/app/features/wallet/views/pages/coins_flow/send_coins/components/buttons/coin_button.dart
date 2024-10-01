// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class CoinButton extends StatelessWidget {
  const CoinButton({
    required this.coinData,
    required this.onTap,
    super.key,
  });

  final CoinData coinData;
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
          coinData.name,
          style: textTheme.body,
        ),
        subtitle: Text(
          coinData.abbreviation,
          style: textTheme.caption3,
        ),
        backgroundColor: Colors.transparent,
        leading: coinData.iconUrl.icon(size: 36.0.s),
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  coinData.amount.toString(),
                  style: textTheme.body,
                ),
                Text(
                  formatToCurrency(coinData.balance),
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
