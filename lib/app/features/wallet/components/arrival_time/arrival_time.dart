// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/components/arrival_time/arrival_time_indicator.dart';

class ArrivalTime extends StatelessWidget {
  const ArrivalTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.i18n.wallet_arrival_time,
          style: context.theme.appTextThemes.body,
        ),
        const Spacer(),
        const ArrivalTimeIndicator(),
      ],
    );
  }
}
