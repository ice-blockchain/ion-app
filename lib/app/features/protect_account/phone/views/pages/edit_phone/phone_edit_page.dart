// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/components/two_fa_success_step.dart';
import 'package:ion/app/features/protect_account/model/two_fa_action_type.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/edit_phone/components/phone_edit_confirm_new_phone_step.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/edit_phone/components/phone_edit_new_phone_input_step.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/edit_phone/components/phone_edit_twofa_input_step.dart';
import 'package:ion/app/features/protect_account/phone/views/pages/edit_phone/components/phone_edit_twofa_options_step.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/edit_twofa_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.m.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class PhoneEditPage extends HookConsumerWidget {
  const PhoneEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(EditTwofaStep.input);
    final newPhone = useRef<String>('');

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: switch (step.value) {
        EditTwofaStep.input => PhoneEditNewPhoneInputStep(
            onNext: (phone) {
              newPhone.value = phone;
              step.value = EditTwofaStep.twoFaOptions;
            },
          ),
        EditTwofaStep.twoFaOptions => PhoneEditTwoFaOptionsStep(
            onNext: () => step.value = EditTwofaStep.twoFaInput,
            onPrevious: () => step.value = EditTwofaStep.input,
          ),
        EditTwofaStep.twoFaInput => PhoneEditTwoFaInputStep(
            phone: newPhone.value,
            onNext: () => step.value = EditTwofaStep.confirmation,
            onPrevious: () => step.value = EditTwofaStep.twoFaOptions,
          ),
        EditTwofaStep.confirmation => PhoneEditConfirmNewPhoneStep(
            phone: newPhone.value,
            onNext: () => showSimpleBottomSheet<void>(
              context: context,
              isDismissible: false,
              child: const TwoFaSuccessStep(
                actionType: TwoFaActionType.phoneUpdate,
              ),
            ),
            onPrevious: () => step.value = EditTwofaStep.twoFaInput,
          ),
      },
    );
  }
}
