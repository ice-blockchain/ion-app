// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/utils/num.dart';

class TransactionAmountSummary extends StatelessWidget {
  const TransactionAmountSummary({
    required this.amount,
    required this.currency,
    required this.usdAmount,
    required this.icon,
    super.key,
  });

  final double amount;
  final String currency;
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
              '-${formatCrypto(amount, currency)}',
              style: textTheme.headline2,
            ),
          ],
        ),
        SizedBox(height: 4.0.s),
        Text(
          context.i18n.wallet_transaction_summary_usd_amount(formatUSD(usdAmount)),
          style: textTheme.caption2.copyWith(
            color: colors.secondaryText,
          ),
        ),
      ],
    );
  }
}
