// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/auth/providers/login_action_notifier.dart';
import 'package:ion/app/features/auth/views/components/identity_key_name_input/identity_key_name_input.dart';
import 'package:ion/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ion/generated/assets.gen.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identityKeyNameController = useTextEditingController();
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();
    final formKey = useRef(GlobalKey<FormState>());

    final authState = ref.watch(authProvider);
    final loginActionState = ref.watch(loginActionNotifierProvider);

    ref.listen(loginActionNotifierProvider, (_, next) {
      if (next.hasValue) {
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
            errorText: loginActionState.error?.toString(),
            controller: identityKeyNameController,
            scrollPadding: EdgeInsets.only(bottom: 190.0.s),
          ),
          SizedBox(height: 16.0.s),
          Button(
            disabled: loginActionState.isLoading,
            trailingIcon: loginActionState.isLoading ||
                    (authState.valueOrNull?.hasAuthenticated).falseOrValue
                ? const IceLoadingIndicator()
                : Assets.svg.iconButtonNext.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () {
              if (formKey.value.currentState!.validate()) {
                hideKeyboardAndCallOnce(
                  callback: () => ref
                      .read(loginActionNotifierProvider.notifier)
                      .signIn(keyName: identityKeyNameController.text),
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
