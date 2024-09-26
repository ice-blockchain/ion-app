import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaOptionsSelectorButton extends StatelessWidget {
  const TwoFaOptionsSelectorButton({
    required this.state,
    required this.isOpened,
    required this.controller,
    required this.optionIndex,
    super.key,
  });

  final FormFieldState<TwoFaType?> state;
  final ValueNotifier<bool> isOpened;
  final MenuController controller;
  final int optionIndex;

  @override
  Widget build(BuildContext context) {
    final iconBorderSize = Border.fromBorderSide(
      BorderSide(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
    );

    return Button.dropdown(
      useDefaultBorderRadius: true,
      useDefaultPaddings: true,
      backgroundColor: context.theme.appColors.secondaryBackground,
      borderColor: state.hasError
          ? context.theme.appColors.attentionRed
          : context.theme.appColors.strokeElements,
      leadingIcon: ButtonIconFrame(
        color: context.theme.appColors.tertararyBackground,
        icon: (state.value?.iconAsset ?? Assets.svg.iconSelect2).icon(
          size: 20.0.s,
          color: context.theme.appColors.secondaryText,
        ),
        border: iconBorderSize,
      ),
      label: SizedBox(
        width: double.infinity,
        child: Text(
          state.value?.getDisplayName(context) ?? context.i18n.two_fa_select(optionIndex),
        ),
      ),
      opened: isOpened.value,
      onPressed: () {
        isOpened.value = !isOpened.value;
        if (controller.isOpen) {
          controller.close();
        } else {
          controller.open();
        }
      },
    );
  }
}
