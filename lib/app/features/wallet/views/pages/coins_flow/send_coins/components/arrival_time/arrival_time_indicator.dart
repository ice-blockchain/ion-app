import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_selectors.dart';
import 'package:ice/generated/assets.gen.dart';

class ArrivalTimeIndicator extends HookConsumerWidget {
  const ArrivalTimeIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;

    final arrivalTime = arrivalTimeSelector(ref);

    return Row(
      children: <Widget>[
        Text(
          locale.wallet_arrival_time_type_normal,
          style: textTheme.body2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        SizedBox(width: 5.0.s),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.s,
            vertical: 4.0.s,
          ),
          decoration: BoxDecoration(
            color: colors.onSecondaryBackground,
            borderRadius: BorderRadius.circular(15.0.s),
          ),
          child: Row(
            children: <Widget>[
              Assets.images.icons.iconBlockTime.icon(
                size: 12.0.s,
              ),
              SizedBox(width: 5.0.s),
              Text(
                '$arrivalTime ${locale.wallet_arrival_time_minutes}',
                style: textTheme.body2.copyWith(
                  color: colors.primaryAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
