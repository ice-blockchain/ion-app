// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_initial_step.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_input_step.dart';
import 'package:ion/app/features/protect_account/authenticator/views/pages/delete_authenticator/components/delete_authenticator_select_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.m.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class AuthenticatorDeletePage extends HookWidget {
  const AuthenticatorDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final step = useState(DeleteTwoFAStep.initial);

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: switch (step.value) {
        DeleteTwoFAStep.initial => DeleteAuthenticatorInitialStep(
            onNext: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
        DeleteTwoFAStep.selectOptions => DeleteAuthenticatorSelectOptionsStep(
            onNext: () => step.value = DeleteTwoFAStep.input,
            onPrevious: () => Navigator.of(context).pop(),
          ),
        DeleteTwoFAStep.input => DeleteAuthenticatorInputStep(
            onNext: () => AuthenticatorDeleteSuccessRoute().push<void>(context),
            onPrevious: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
      },
    );
  }
}
