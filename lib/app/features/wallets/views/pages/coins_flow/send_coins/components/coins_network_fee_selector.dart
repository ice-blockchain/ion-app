// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/network_fee_selector.dart';

class CoinsNetworkFeeSelector extends ConsumerWidget {
  const CoinsNetworkFeeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(sendAssetFormControllerProvider);
    final options = formData.networkFeeOptions;
    final selectedOption = formData.selectedNetworkFeeOption;

    return NetworkFeeSelector(
      options: options,
      selectedOption: selectedOption,
      onChanged: (value) {
        ref.read(sendAssetFormControllerProvider.notifier).selectNetworkFeeOption(options[value]);
      },
    );
  }
}
