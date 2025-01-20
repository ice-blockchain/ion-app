// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/slider/app_slider.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/network_fee.dart';

class ArrivalTimeSelector extends StatelessWidget {
  const ArrivalTimeSelector({
    required this.arrivalTimeInMinutes,
    required this.onArrivalTimeChanged,
    super.key,
  });

  final int arrivalTimeInMinutes;
  final void Function(int) onArrivalTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ArrivalTime(arrivalTimeInMinutes: arrivalTimeInMinutes),
        SizedBox(height: 12.0.s),
        AppSlider(
          initialValue: arrivalTimeInMinutes.toDouble(),
          onChanged: (double value) {
            onArrivalTimeChanged(value.toInt());
          },
        ),
        SizedBox(height: 8.0.s),
        const NetworkFee(),
      ],
    );
  }
}
