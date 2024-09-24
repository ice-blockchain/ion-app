import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';

class SignUpPasskeyForm extends HookConsumerWidget {
  const SignUpPasskeyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());
    final authState = ref.watch(authProvider);

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          IdentityKeyNameInput(controller: identityKeyNameController),
          SizedBox(height: 16.0.s),
          Button(
            disabled: authState.isLoading,
            trailingIcon:
                authState.isLoading || (authState.valueOrNull?.hasAuthenticated).falseOrValue
                    ? const IceLoadingIndicator()
                    : SizedBox.shrink(),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                hideKeyboardAndCallOnce(
                  callback: () => ref
                      .read(authProvider.notifier)
                      .signUp(keyName: identityKeyNameController.text),
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
