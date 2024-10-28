// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/register_action_notifier.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';

class SignUpPasskeyForm extends HookConsumerWidget {
  const SignUpPasskeyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());

    final authState = ref.watch(authProvider);
    final registerActionState = ref.watch(registerActionNotifierProvider);

    ref.listen(registerActionNotifierProvider, (_, next) {
      if (next.hasError && next.error != null) {
        showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(next.error.toString()),
          ),
        );
      }
    });

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          IdentityKeyNameInput(
            errorText: registerActionState.error?.toString(),
            controller: identityKeyNameController,
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: registerActionState.isLoading,
            trailingIcon: registerActionState.isLoading ||
                    authState.valueOrNull?.hasAuthenticated.falseOrValue
                ? const IceLoadingIndicator()
                : const SizedBox.shrink(),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                hideKeyboardAndCallOnce(
                  callback: () => ref
                      .read(registerActionNotifierProvider.notifier)
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
