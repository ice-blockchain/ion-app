// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/providers/coins_provider.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.dart';

class CoinAmountInput extends ConsumerWidget {
  const CoinAmountInput({
    required this.controller,
    required this.coinId,
    this.showMaxAction = true,
    this.showApproximateInUsd = true,
    super.key,
  });

  final TextEditingController controller;
  final bool showMaxAction;
  final bool showApproximateInUsd;
  final String coinId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;

    final walletBalance = ref.watch(currentWalletDataProvider).valueOrNull?.balance ?? 0;
    final coinData = ref.watch(coinByIdProvider(coinId: coinId)).valueOrNull;

    return Column(
      children: [
        TextInput(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            final amount = double.tryParse(value);
            if (amount == null) {
              return '';
            }
            return null;
          },
          labelText: locale.wallet_coin_amount(coinData?.abbreviation ?? ''),
          suffixIcon: showMaxAction
              ? TextInputTextButton(
                  onPressed: () {
                    controller.text = walletBalance.toString();
                  },
                  label: locale.wallet_max,
                )
              : null,
        ),
        if (showApproximateInUsd)
          Column(
            children: [
              SizedBox(height: 6.0.s),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  locale.wallet_approximate_in_usd('21.43'),
                  style: textTheme.caption2.copyWith(
                    color: colors.tertararyText,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
