// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/delete_phone/components/delete_phone_initial_step.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/delete_phone/components/delete_phone_input_step.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/delete_phone/components/delete_phone_select_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class PhoneDeletePage extends HookWidget {
  const PhoneDeletePage({super.key});

  @override
  Widget build(BuildContext context) {
    final step = useState(DeleteTwoFAStep.initial);

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: switch (step.value) {
        DeleteTwoFAStep.initial => DeletePhoneInitialStep(
            onNext: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
        DeleteTwoFAStep.selectOptions => DeletePhoneSelectOptionsStep(
            onNext: () => step.value = DeleteTwoFAStep.input,
            onPrevious: () => step.value = DeleteTwoFAStep.initial,
          ),
        DeleteTwoFAStep.input => DeletePhoneInputStep(
            onNext: () => PhoneDeleteSuccessRoute().push<void>(context),
            onPrevious: () => step.value = DeleteTwoFAStep.selectOptions,
          ),
      },
    );
  }
}
