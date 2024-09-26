import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/identity_key_name_input/identity_info.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class IdentityKeyNameInput extends HookWidget {
  const IdentityKeyNameInput({
    this.textInputAction = TextInputAction.done,
    super.key,
    this.controller,
    this.scrollPadding,
    this.notShowInfoIcon = false,
  });

  final TextEditingController? controller;

  final TextInputAction textInputAction;

  final EdgeInsets? scrollPadding;
  final bool notShowInfoIcon;

  @override
  Widget build(BuildContext context) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    return TextInput(
      keyboardType: TextInputType.emailAddress,
      prefixIcon: TextInputIcons(
        hasRightDivider: true,
        icons: [Assets.svg.iconIdentitykey.icon()],
      ),
      suffixIcon: notShowInfoIcon
          ? null
          : TextInputIcons(icons: [
              SizedBox.square(
                dimension: 40.0.s,
                child: IconButton(
                  icon: Assets.svg.iconBlockInformation.icon(),
                  onPressed: () {
                    hideKeyboardAndCallOnce(callback: () {
                      showSimpleBottomSheet<void>(
                        context: context,
                        child: const IdentityInfo(),
                        useRootNavigator: false,
                      );
                    },);
                  },
                ),
              ),
            ],),
      labelText: context.i18n.common_identity_key_name,
      controller: controller,
      validator: (String? value) {
        if (Validators.isEmpty(value)) return '';
        return null;
      },
      textInputAction: textInputAction,
      scrollPadding: scrollPadding ?? EdgeInsets.only(bottom: 100.0.s),
    );
  }
}
