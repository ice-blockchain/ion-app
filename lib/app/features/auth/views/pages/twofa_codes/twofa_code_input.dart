// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.dart';
import 'package:ion/app/hooks/use_countdown.dart';
import 'package:ion/app/utils/validators.dart';

class TwoFaCodeInput extends StatelessWidget {
  const TwoFaCodeInput({
    required this.controller,
    required this.twoFaType,
    this.onRequestCode,
    this.isSending = false,
    super.key,
  });

  final TextEditingController controller;
  final TwoFaType twoFaType;
  final VoidCallback? onRequestCode;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [twoFaType.iconAsset.icon()],
      ),
      labelText: twoFaType.getDisplayName(context),
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        return null;
      },
      textInputAction: TextInputAction.next,
      scrollPadding: EdgeInsets.only(bottom: 200.0.s),
      keyboardType: TextInputType.number,
      suffixIcon: switch (twoFaType) {
        TwoFaType.email || TwoFaType.sms => SendButton(
            onRequestCode: onRequestCode,
            isSending: isSending,
          ),
        TwoFaType.auth => null,
      },
    );
  }
}

class SendButton extends HookConsumerWidget {
  const SendButton({
    this.onRequestCode,
    this.isSending = false,
    super.key,
  });

  final VoidCallback? onRequestCode;
  final bool isSending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSent = useState(false);
    final countdownState = useCountdown(60);
    final countdown = countdownState.countdown;
    final startCountdown = countdownState.startCountdown;

    final isLightTheme = ref.watch(appThemeModeProvider) == ThemeMode.light;

    return countdown.value > 0
        ? Padding(
            padding: EdgeInsets.all(14.0.s),
            child: Text(
              context.i18n.common_seconds(countdown.value),
              style: context.theme.appTextThemes.caption.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
          )
        : isSending
            ? IONLoadingIndicator(type: isLightTheme ? IndicatorType.dark : IndicatorType.light)
            : TextInputTextButton(
                onPressed: () {
                  onRequestCode?.call();
                  isSent.value = true;
                  startCountdown();
                },
                label: isSent.value ? context.i18n.button_retry : context.i18n.button_send,
              );
  }
}
