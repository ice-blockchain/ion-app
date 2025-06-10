// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/arrival_time_indicator.dart';

class ArrivalTime extends StatelessWidget {
  const ArrivalTime({
    required this.option,
    super.key,
  });

  final NetworkFeeOption option;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.i18n.wallet_arrival_time,
          style: context.theme.appTextThemes.body,
        ),
        const Spacer(),
        ArrivalTimeIndicator(option: option),
      ],
    );
  }
}
