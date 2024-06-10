import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/arrival_time/arrival_time_indicator.dart';

class ArrivalTime extends StatelessWidget {
  const ArrivalTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'Arrival time',
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        const Spacer(),
        const ArrivalTimeIndicator(),
      ],
    );
  }
}
