// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/components/two_fa_success_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_initial_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_input_step.dart';
import 'package:ion/app/features/protect_account/email/views/pages/delete_email/components/delete_email_select_options_step.dart';
import 'package:ion/app/features/protect_account/model/two_fa_action_type.dart';
import 'package:ion/app/features/protect_account/secure_account/data/models/delete_twofa_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/selected_two_fa_types_provider.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class EmailDeletePage extends HookConsumerWidget {
  const EmailDeletePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = useState(DeleteTwoFAStep.initial);

    return ProviderScope(
      overrides: [
        availableTwoFaTypesProvider.overrideWith(securityMethodsEnabledTypes),
      ],
      child: Consumer(
        builder: (context, ref, _) => switch (step.value) {
          DeleteTwoFAStep.initial => DeleteEmailInitialStep(
              onNext: () => _onInitiateDelete(ref, step),
            ),
          DeleteTwoFAStep.selectOptions => DeleteEmailSelectOptionsStep(
              onNext: () => step.value = DeleteTwoFAStep.input,
              onPrevious: () => step.value = DeleteTwoFAStep.initial,
            ),
          DeleteTwoFAStep.input => DeleteEmailInputStep(
              onNext: () => showSimpleBottomSheet<void>(
                context: context,
                isDismissible: false,
                child: const TwoFaSuccessStep(
                  actionType: TwoFaActionType.emailDelete,
                ),
              ),
              onPrevious: () => step.value = DeleteTwoFAStep.selectOptions,
            ),
        },
      ),
    );
  }

  void _onInitiateDelete(WidgetRef ref, ValueNotifier<DeleteTwoFAStep> step) {
    final enabledTwoFaOptions = ref.read(availableTwoFaTypesProvider);
    if (enabledTwoFaOptions.count > 1) {
      _showCantRemoveEmailModal(ref);
    } else {
      step.value = DeleteTwoFAStep.selectOptions;
    }
  }

  void _showCantRemoveEmailModal(WidgetRef ref) {
    showSimpleBottomSheet<void>(
      context: ref.context,
      child: SimpleModalSheet.alert(
        iconAsset: Assets.svgactionWalletKeyserror,
        title: ref.context.i18n.two_fa_delete_email_button,
        description: ref.context.i18n.two_fa_delete_email_cant_remove_description,
        buttonText: ref.context.i18n.button_close,
        isBottomSheet: true,
        bottomOffset: 0.0.s,
        topOffset: 30.0.s,
      ),
    );
  }
}
