// SPDX-License-Identifier: ice License 1.0

part of '../money_message.dart';

class _AmountDisplay extends HookWidget {
  const _AmountDisplay({
    required this.amount,
    required this.equivalentUsd,
    required this.chain,
    required this.isMe,
    required this.coin,
  });

  final double amount;
  final double equivalentUsd;
  final String chain;
  final String? coin;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final textColor = useMemoized(
      () => isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
      [isMe],
    );

    final secondaryTextColor = useMemoized(
      () => isMe ? context.theme.appColors.strokeElements : context.theme.appColors.quaternaryText,
      [isMe],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              formatCrypto(amount, coin.emptyOrValue.isEmpty ? '' : '$coin '),
              style: context.theme.appTextThemes.subtitle3.copyWith(color: textColor),
            ),
            SizedBox(width: 4.0.s),
            Text(
              context.i18n.wallet_approximate_in_usd(
                formatUSD(equivalentUsd),
              ),
              style: context.theme.appTextThemes.body2.copyWith(color: secondaryTextColor),
            ),
          ],
        ),
        SizedBox(height: 4.0.s),
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? context.theme.appColors.terararyBackground
                : context.theme.appColors.onSecondaryBackground,
            borderRadius: BorderRadius.circular(4.0.s),
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.0.s),
          child: Text(
            chain,
            style: context.theme.appTextThemes.caption3
                .copyWith(color: context.theme.appColors.quaternaryText),
          ),
        ),
      ],
    );
  }
}
