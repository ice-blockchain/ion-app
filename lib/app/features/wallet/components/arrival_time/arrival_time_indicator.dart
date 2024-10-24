// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ArrivalTimeIndicator extends StatelessWidget {
  const ArrivalTimeIndicator({
    required this.arrivalTimeInMinutes,
    super.key,
  });

  final int arrivalTimeInMinutes;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;

    return Row(
      children: [
        Text(
          locale.wallet_arrival_time_type_normal,
          style: textTheme.body2.copyWith(
            color: colors.secondaryText,
          ),
        ),
        SizedBox(width: 6.0.s),
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
            children: [
              Assets.svg.iconBlockTime.icon(
                size: 12.0.s,
              ),
              SizedBox(width: 5.0.s),
              Text(
                '$arrivalTimeInMinutes ${locale.wallet_arrival_time_minutes}',
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
