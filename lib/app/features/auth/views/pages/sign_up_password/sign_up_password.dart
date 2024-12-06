// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/register_action_notifier.c.dart';
import 'package:ion/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ion/app/features/auth/views/pages/sign_up_password/password_input.dart';
import 'package:ion/app/features/auth/views/pages/sign_up_password/sign_up_password_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SignUpPasswordPage extends HookConsumerWidget {
  const SignUpPasswordPage({super.key});

  static double get _footerHeight => 92.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordConfirmationController = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());
    final checkboxSelected = useState(false);
    final checkboxHighlighted = useState(false);

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: AuthScrollContainer(
          title: context.i18n.sign_up_password_title,
          description: context.i18n.sign_up_password_description,
          icon: Assets.svg.iconLoginPassword.icon(size: 36.0.s),
          children: [
            ScreenSideOffset.large(
              child: Form(
                key: formKey.value,
                child: Column(
                  children: [
                    SizedBox(height: 60.0.s),
                    IdentityKeyNameInput(
                      controller: identityKeyNameController,
                      textInputAction: TextInputAction.next,
                      scrollPadding: EdgeInsets.only(bottom: 250.0.s),
                    ),
                    SizedBox(height: 16.0.s),
                    PasswordInput(controller: passwordController),
                    SizedBox(height: 16.0.s),
                    PasswordInput(
                      controller: passwordConfirmationController,
                      isConfirmation: true,
                    ),
                    SizedBox(height: 20.0.s),
                    SignUpPasswordButton(
                      onPressed: () {
                        final valid = formKey.value.currentState!.validate();
                        if (checkboxSelected.value) {
                          if (valid) {
                            ref
                                .read(registerActionNotifierProvider.notifier)
                                .signUp(keyName: identityKeyNameController.text);
                          }
                        } else {
                          checkboxHighlighted.value = true;
                        }
                      },
                    ),
                    SizedBox(
                      height: 56.0.s,
                    ),
                    const AuthFooter(),
                  ],
                ),
              ),
            ),
            ScreenBottomOffset(margin: _footerHeight),
          ],
        ),
      ),
    );
  }
}
