import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/extensions.dart';

class ArrivalTimeIndicator extends StatelessWidget {
  const ArrivalTimeIndicator({super.key});

  // TODO @ice-alcides): Replace with dynamic value
  static const String time = '15 min';

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;

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
            horizontal: UiSize.xxSmall,
            vertical: UiSize.xxxSmall,
          ),
          decoration: BoxDecoration(
            color: colors.onSecondaryBackground,
            borderRadius: BorderRadius.circular(15.0.s),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                color: colors.primaryAccent,
                size: UiSize.medium,
              ),
              SizedBox(width: 5.0.s),
              Text(
                time,
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
