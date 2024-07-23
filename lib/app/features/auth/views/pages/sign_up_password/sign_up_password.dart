import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ice/app/features/auth/views/components/sign_up_list_item/sign_up_list_item.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/password_input.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_fixed_footer.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_password_button.dart';
import 'package:ice/app/features/auth/views/pages/sign_up_password/sign_up_password_checkbox.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SignUpPasswordPage extends HookConsumerWidget {
  const SignUpPasswordPage({super.key});

  static double get _footerHeight => 92.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final identityKeyNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());
    final checkboxSelected = useState(false);
    final checkboxHighlighted = useState(false);

    return SheetContent(
      body: Stack(
        children: [
          KeyboardDismissOnTap(
            child: AuthScrollContainer(
              title: context.i18n.sign_up_password_title,
              description: context.i18n.sign_up_password_description,
              icon: Assets.images.icons.iconLoginPassword.icon(size: 36.0.s),
              children: [
                ScreenSideOffset.large(
                  child: Form(
                    key: formKey.value,
                    child: Column(
                      children: [
                        SizedBox(height: 32.0.s),
                        SignUpListItem(
                          title: context.i18n.sign_up_password_disadvantage_1_title,
                          subtitle: context.i18n.sign_up_password_disadvantage_1_description,
                          icon: Assets.images.icons.iconLoginHack.icon(),
                        ),
                        SignUpListItem(
                          title: context.i18n.sign_up_password_disadvantage_2_title,
                          subtitle: context.i18n.sign_up_password_disadvantage_2_description,
                          icon: Assets.images.icons.iconLoginReused.icon(),
                        ),
                        SignUpListItem(
                          title: context.i18n.sign_up_password_disadvantage_3_title,
                          subtitle: context.i18n.sign_up_password_disadvantage_3_description,
                          icon: Assets.images.icons.iconLoginManage.icon(),
                        ),
                        SizedBox(height: 18.0.s),
                        IdentityKeyNameInput(
                          controller: identityKeyNameController,
                          textInputAction: TextInputAction.next,
                          scrollPadding: EdgeInsets.only(bottom: 250.0.s),
                        ),
                        SizedBox(height: 16.0.s),
                        PasswordInput(controller: passwordController),
                        SizedBox(height: 17.0.s),
                        SignUpPasswordCheckbox(
                          selected: checkboxSelected.value,
                          highlighted: checkboxHighlighted.value,
                          onToggle: () {
                            checkboxHighlighted.value = false;
                            checkboxSelected.value = !checkboxSelected.value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ScreenBottomOffset(margin: _footerHeight),
              ],
            ),
          ),
          SignUpFixedFooter(
            height: _footerHeight,
            child: SignUpPasswordButton(
              onPressed: () {
                final valid = formKey.value.currentState!.validate();
                if (checkboxSelected.value) {
                  if (valid) {
                    hideKeyboardAndCallOnce(
                      callback: () => ref
                          .read(authProvider.notifier)
                          .signIn(keyName: identityKeyNameController.text),
                    );
                  }
                } else {
                  checkboxHighlighted.value = true;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
