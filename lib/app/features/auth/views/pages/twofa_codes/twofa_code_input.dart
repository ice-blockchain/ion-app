import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/hooks/use_countdown.dart';
import 'package:ice/app/utils/validators.dart';

class TwoFaCodeInput extends HookWidget {
  const TwoFaCodeInput({required this.controller, required this.twoFaType, super.key});

  final TextEditingController controller;
  final TwoFaType twoFaType;

  @override
  Widget build(BuildContext context) {
    final isSent = useState(false);
    final countdownState = useCountdown(60);
    final countdown = countdownState.countdown;
    final startCountdown = countdownState.startCountdown;

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
      suffixIcon: countdown.value > 0
          ? Padding(
              padding: EdgeInsets.all(14.0.s),
              child: Text(
                context.i18n.common_seconds(countdown.value),
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.tertararyText,
                ),
              ),
            )
          : TextInputTextButton(
              onPressed: () {
                isSent.value = true;
                startCountdown();
              },
              label: isSent.value ? context.i18n.button_retry : context.i18n.button_send,
            ),
    );
  }
}
