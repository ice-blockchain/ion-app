import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class TransactionAmountSummary extends StatelessWidget {
  const TransactionAmountSummary({
    required this.usdtAmount,
    required this.usdAmount,
    required this.icon,
    super.key,
  });

  final double usdtAmount;
  final double usdAmount;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 8.0.s),
            Text(
              '-$usdtAmount USDT',
              style: textTheme.headline2,
            ),
          ],
        ),
        SizedBox(height: 4.0.s),
        Text(
          '~ $usdAmount USD',
          style: textTheme.caption2.copyWith(
            color: colors.secondaryText,
          ),
        ),
      ],
    );
  }
}
