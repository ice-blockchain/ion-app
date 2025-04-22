// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/utils/amount_parser.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/utils/num.dart';

class CoinAmountInput extends HookWidget {
  const CoinAmountInput({
    required this.controller,
    this.balanceUSD,
    this.maxValue,
    this.coinAbbreviation,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final double? balanceUSD;
  final double? maxValue;
  final String? coinAbbreviation;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final colors = context.theme.appColors;
    final textTheme = context.theme.appTextThemes;

    final error = useState<String?>(null);
    final label = locale.wallet_coin_amount(coinAbbreviation ?? '');

    useEffect(
      () {
        void validate() {
          final value = controller.text;
          final parsed = parseAmount(value);
          final errorText = switch (parsed) {
            null => label,
            double() when parsed < 0 => label,
            double() when maxValue != null && parsed > maxValue! =>
              locale.wallet_coin_amount_insufficient_funds,
            _ => null,
          };

          if (error.value != errorText) {
            error.value = errorText;
          }
        }

        controller.addListener(validate);
        validate(); // Initial check

        return () => controller.removeListener(validate);
      },
      [controller, maxValue, coinAbbreviation],
    );

    return Column(
      children: [
        TextInput(
          enabled: enabled,
          controller: controller,
          errorText: error.value,
          autoValidateMode: AutovalidateMode.always,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            final parsed = parseAmount(value ?? '');

            // Error text will be displayed in the label, so pass an empty string here
            const error = '';

            if (parsed == null) return error;
            if ((maxValue != null && parsed > maxValue!) || parsed < 0) return error;

            return null;
          },
          labelText: label,
          suffixIcon: maxValue != null && enabled
              ? Padding(
                  padding: EdgeInsetsDirectional.only(end: 16.0.s),
                  child: TextButton(
                    onPressed: () {
                      controller.text = formatCrypto(maxValue ?? 0);
                    },
                    child: Text(
                      locale.wallet_max,
                      style: textTheme.caption.copyWith(
                        color: error.value == null
                            ? context.theme.appColors.primaryAccent
                            : context.theme.appColors.attentionRed,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        if (balanceUSD != null)
          Column(
            children: [
              SizedBox(height: 6.0.s),
              Align(
                alignment: AlignmentDirectional.centerStart,
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
