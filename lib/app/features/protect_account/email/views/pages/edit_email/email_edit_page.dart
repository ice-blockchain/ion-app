// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/email/data/model/email_edit_steps.dart';
import 'package:ion/app/features/protect_account/email/views/pages/edit_email/components/email_edit_confirm_new_email_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/edit_email/components/email_edit_new_email_input_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/edit_email/components/email_edit_twofa_input_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/edit_email/components/email_edit_twofa_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class EmailEditPage extends HookConsumerWidget {
  const EmailEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(EmailEditSteps.input);
    final newEmail = useRef<String>('');

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: switch (step.value) {
        EmailEditSteps.input => EmailEditNewEmailInputStep(
            onNext: (email) {
              newEmail.value = email;
              step.value = EmailEditSteps.twoFaOptions;
            },
          ),
        EmailEditSteps.twoFaOptions => EmailEditTwoFaOptionsStep(
            onNext: () => step.value = EmailEditSteps.twoFaInput,
          ),
        EmailEditSteps.twoFaInput => EmailEditTwoFaInputStep(
            email: newEmail.value,
            onNext: () => step.value = EmailEditSteps.confirmation,
          ),
        EmailEditSteps.confirmation => EmailEditConfirmNewEmailStep(
            email: newEmail.value,
            onNext: () => EmailEditSuccessRoute().push<void>(context),
          ),
      },
    );
  }
}
