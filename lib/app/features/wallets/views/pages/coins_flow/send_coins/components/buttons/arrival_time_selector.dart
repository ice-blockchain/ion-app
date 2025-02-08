// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/slider/app_slider.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/network_fee.dart';

class ArrivalTimeSelector extends ConsumerWidget {
  const ArrivalTimeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(sendAssetFormControllerProvider());
    final options = formData.networkFeeOptions;
    final selectedOption = formData.selectedNetworkFeeOption;

    if (options.isEmpty || selectedOption == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ArrivalTime(option: selectedOption),
        SizedBox(height: 12.0.s),
        AppSlider(
          maxValue: options.length - 1,
          stops: List.generate(options.length, (i) => i.toDouble()),
          initialValue: options.indexOf(selectedOption).toDouble(),
          onChanged: (value) {
            final selectedOption = options[value.toInt()];
            ref
                .read(sendAssetFormControllerProvider().notifier)
                .selectNetworkFeeOption(selectedOption);
          },
        ),
        SizedBox(height: 8.0.s),
        NetworkFeeOptionWidget(feeOption: selectedOption),
      ],
    );
  }
}
