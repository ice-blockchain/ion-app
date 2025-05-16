// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/slider/app_slider.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/network_fee.dart';

class NetworkFeeSelector extends ConsumerWidget {
  const NetworkFeeSelector({
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    this.padding,
    super.key,
  });

  final List<NetworkFeeOption> options;
  final NetworkFeeOption? selectedOption;
  final ValueChanged<int>? onChanged;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (options.isEmpty || selectedOption == null) {
      return const SizedBox.shrink();
    }

    final showSlider = options.length > 2;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          ArrivalTime(option: selectedOption!),
          if (showSlider) ...[
            SizedBox(height: 12.0.s),
            AppSlider(
              maxValue: options.length - 1,
              stops: List.generate(options.length, (i) => i.toDouble()),
              initialValue: options.indexOf(selectedOption!).toDouble(),
              onChanged: (value) => onChanged?.call(value.toInt()),
            ),
          ],
          SizedBox(height: 8.0.s),
          NetworkFeeOptionWidget(feeOption: selectedOption!),
        ],
      ),
    );
  }
}
