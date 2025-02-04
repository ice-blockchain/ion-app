// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_initial_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_input_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_select_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class EmailDeletePage extends HookWidget {
  const EmailDeletePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final step = useState(DeleteTwoFAStep.initial);

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: switch (step.value) {
        DeleteTwoFAStep.initial => DeleteEmailInitialStep(
            onNext: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
        DeleteTwoFAStep.selectOptions => DeleteEmailSelectOptionsStep(
            onNext: () => step.value = DeleteTwoFAStep.input,
            onPrevious: () => step.value = DeleteTwoFAStep.initial,
          ),
        DeleteTwoFAStep.input => DeleteEmailInputStep(
            onNext: () => EmailDeleteSuccessRoute().push<void>(context),
            onPrevious: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
      },
    );
  }
}
