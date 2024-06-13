import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ArrivalTimeIndicator extends StatelessWidget {
  const ArrivalTimeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          context.i18n.wallet_arrival_time_type_normal,
          style: context.theme.appTextThemes.body2.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
        SizedBox(width: 5.0.s),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.0.s,
            vertical: 4.0.s,
          ),
          decoration: BoxDecoration(
            color: context.theme.appColors.onSecondaryBackground,
            borderRadius: BorderRadius.circular(15.0.s),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                color: context.theme.appColors.primaryAccent,
                size: 16.0.s,
              ),
              SizedBox(width: 5.0.s),
              Text(
                '15 min',
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
