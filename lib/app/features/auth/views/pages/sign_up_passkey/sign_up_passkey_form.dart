// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/register_action_notifier.c.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class SignUpPasskeyForm extends HookConsumerWidget {
  const SignUpPasskeyForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final formKey = useRef(GlobalKey<FormState>());

    final authState = ref.watch(authProvider);
    final registerActionState = ref.watch(registerActionNotifierProvider);

    ref.displayErrors(registerActionNotifierProvider);

    return Form(
      key: formKey.value,
      child: Column(
        children: [
          IdentityKeyNameInput(
            errorText: registerActionState.error is UserAlreadyExistsException
                ? context.i18n.sign_up_passkey_identity_key_name_taken
                : registerActionState.error?.toString(),
            controller: identityKeyNameController,
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: registerActionState.isLoading,
            trailingIcon: registerActionState.isLoading ||
                    (authState.valueOrNull?.isAuthenticated).falseOrValue
                ? const IONLoadingIndicator()
                : Assets.svg.iconButtonNext.icon(
                    size: 24.0.s,
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                guardPasskeyDialog(
                  ref.context,
                  (child) => RiverpodVerifyIdentityRequestBuilder(
                    provider: registerActionNotifierProvider,
                    requestWithVerifyIdentity: (_) {
                      ref
                          .read(registerActionNotifierProvider.notifier)
                          .signUp(keyName: identityKeyNameController.text);
                    },
                    child: child,
                  ),
                );
              }
            },
            label: Text(context.i18n.button_continue),
            mainAxisSize: MainAxisSize.max,
          ),
        ],
      ),
    );
  }
}
