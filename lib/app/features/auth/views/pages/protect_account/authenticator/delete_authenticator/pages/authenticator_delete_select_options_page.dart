import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_steps.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorDeleteSelectOptionsPage extends HookWidget {
  const AuthenticatorDeleteSelectOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextInput(
              controller: controller,
              labelText: context.i18n.two_fa_auth,
              prefixIcon: TextInputIcons(
                hasRightDivider: true,
                icons: [Assets.images.icons.iconRecoveryCode.icon()],
              ),
              validator: (value) => value?.isEmpty == true ? '' : null,
              textInputAction: TextInputAction.done,
              scrollPadding: EdgeInsets.only(bottom: 200.0.s),
            ),
            SizedBox(height: 22.0.s),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () => AuthenticatorDeleteRoute(
                step: AuthenticatorDeleteSteps.input,
              ).push<void>(context),
            )
          ],
        ),
      ),
    );
  }
}
