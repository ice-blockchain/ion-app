// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_initial_step.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_input_step.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_select_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';

class AuthenticatorDeletePage extends HookWidget {
  const AuthenticatorDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final step = useState(DeleteTwoFAStep.initial);

    return switch (step.value) {
      DeleteTwoFAStep.initial => DeleteAuthenticatorInitialStep(
          onButtonPressed: () => step.value = DeleteTwoFAStep.selectOptions,
        ),
      DeleteTwoFAStep.selectOptions => DeleteAuthenticatorSelectOptionsStep(
          onButtonPressed: () => step.value = DeleteTwoFAStep.input,
        ),
      DeleteTwoFAStep.input => const DeleteAuthenticatorInputStep(),
    };
  }
}
