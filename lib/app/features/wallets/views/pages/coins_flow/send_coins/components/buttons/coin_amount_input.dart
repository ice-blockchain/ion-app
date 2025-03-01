// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/app/utils/validators.dart';

class CoinAmountInput extends StatelessWidget {
  const CoinAmountInput({
    required this.controller,
    this.balanceUSD,
    this.maxValue,
    this.coinAbbreviation,
    super.key,
  });

  final TextEditingController controller;
  final double? balanceUSD;
  final double? maxValue;
  final String? coinAbbreviation;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;
    final locale = context.i18n;

    return Column(
      children: [
        TextInput(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (Validators.isEmpty(value)) return '';
            if (Validators.isInvalidNumber(value)) return '';

            return null;
          },
          labelText: locale.wallet_coin_amount(coinAbbreviation ?? ''),
          suffixIcon: maxValue != null
              ? TextInputTextButton(
                  onPressed: () {
                    controller.text = formatCrypto(maxValue ?? 0);
                  },
                  label: locale.wallet_max,
                )
              : null,
        ),
        if (balanceUSD != null)
          Column(
            children: [
              SizedBox(height: 6.0.s),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  locale.wallet_approximate_in_usd(
                    formatUSD(balanceUSD!),
                  ),
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
