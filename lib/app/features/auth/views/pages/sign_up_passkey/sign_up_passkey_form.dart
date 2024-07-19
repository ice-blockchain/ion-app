import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/identity_info/identity_info.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/app/utils/validators.dart';
import 'package:ice/generated/assets.gen.dart';

class SignUpPasskeyForm extends HookConsumerWidget {
  const SignUpPasskeyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityNameController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());
    final authState = ref.watch(authProvider);

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          TextInput(
            prefixIcon: TextInputIcons(
              hasRightDivider: true,
              icons: [Assets.images.icons.iconIdentitykey.icon()],
            ),
            suffixIcon: TextInputIcons(
              icons: [
                IconButton(
                  icon: Assets.images.icons.iconBlockInformation.icon(
                    size: 20.0.s,
                  ),
                  onPressed: () {
                    showSimpleBottomSheet<void>(
                      context: context,
                      child: const IdentityInfo(),
                    );
                  },
                ),
              ],
            ),
            labelText: context.i18n.common_identity_key_name,
            controller: identityNameController,
            validator: (String? value) {
              if (Validators.isEmpty(value)) return '';
              return null;
            },
            textInputAction: TextInputAction.done,
            scrollPadding: EdgeInsets.all(120.0.s),
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: authState is AuthenticationLoading,
            trailingIcon: authState is AuthenticationLoading
                ? const ButtonLoadingIndicator()
                : const SizedBox.shrink(),
            onPressed: () async {
              if (formKey.value.currentState!.validate()) {
                hideKeyboardAndCallOnce(
                  callback: () => ref.read(authProvider.notifier).signIn(
                        keyName: identityNameController.text,
                      ),
                );
              }
            },
            label: Text(context.i18n.sign_up_passkey_button),
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
