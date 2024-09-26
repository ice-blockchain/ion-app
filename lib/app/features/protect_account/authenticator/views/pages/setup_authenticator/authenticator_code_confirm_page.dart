import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorCodeConfirmPage extends HookWidget {
  const AuthenticatorCodeConfirmPage({
    required this.onFormKeySet,
    super.key,
  });
  final void Function(GlobalKey<FormState>) onFormKeySet;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());

    useOnInit(
      () {
        onFormKeySet(formKey.value);
      },
      [],
    );

    return Form(
      key: formKey.value,
      child: Center(
        child: ScreenSideOffset.large(
          child: TextInput(
            controller: controller,
            labelText: context.i18n.two_fa_auth,
            prefixIcon: TextInputIcons(
              hasRightDivider: true,
              icons: [Assets.svg.iconRecoveryCode.icon()],
            ),
            validator: (value) => (value?.isEmpty ?? false) ? '' : null,
            textInputAction: TextInputAction.done,
            scrollPadding: EdgeInsets.only(bottom: 200.0.s),
          ),
        ),
      ),
    );
  }
}
