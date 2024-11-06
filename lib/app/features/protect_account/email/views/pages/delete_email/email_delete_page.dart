// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_initial_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_input_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_select_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';

class EmailDeletePage extends HookWidget {
  const EmailDeletePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final step = useState(DeleteTwoFAStep.initial);

    return switch (step.value) {
      DeleteTwoFAStep.initial => DeleteEmailInitialStep(
          onButtonPressed: () => step.value = DeleteTwoFAStep.selectOptions,
        ),
      DeleteTwoFAStep.selectOptions => DeleteEmailSelectOptionsStep(
          onButtonPressed: () => step.value = DeleteTwoFAStep.input,
        ),
      DeleteTwoFAStep.input => const DeleteEmailInputStep(),
    };
  }
}
