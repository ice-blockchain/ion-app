// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/pages/twofa_options/twofa_option_selector.dart';
import 'package:ion/app/features/protect_account/authenticator/data/model/authenticator_steps.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.dart';
import 'package:ion/app/router/app_routes.dart';

class AuthenticatorDeleteSelectOptionsPage extends HookConsumerWidget {
  const AuthenticatorDeleteSelectOptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticatorOptionsState = ref.watch(authenticatorDeleteOptionsProvider);
    final formKey = useRef(GlobalKey<FormState>());

    return ScreenSideOffset.large(
      child: Form(
        key: formKey.value,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              authenticatorOptionsState.optionsAmount,
              (option) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 22.0.s),
                  child: TwoFaOptionSelector(
                    availableOptions: authenticatorOptionsState.availableOptions,
                    optionIndex: option + 1,
                    onSaved: (value) {
                      ref
                          .read(authenticatorDeleteOptionsProvider.notifier)
                          .updateSelectedTwoFaOption(option, value);
                    },
                  ),
                );
              },
            ),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.button_confirm),
              onPressed: () {
                formKey.value.currentState!.save();
                if (formKey.value.currentState!.validate()) {
                  AuthenticatorDeleteRoute(step: AuthenticatorDeleteSteps.input)
                      .push<void>(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
