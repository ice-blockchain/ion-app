// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_select_options_step.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_step_scaffold.dart';
import 'package:ion/generated/assets.gen.dart';

class DeletePhoneSelectOptionsStep extends HookWidget {
  const DeletePhoneSelectOptionsStep({required this.onButtonPressed, super.key});

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return DeleteTwoFAStepScaffold(
      headerIcon: Assets.svg.icon2faEmailauth.icon(size: 36.0.s),
      headerTitle: locale.two_fa_deleting_phone_title,
      headerDescription: locale.two_fa_deleting_phone_description,
      child: DeleteTwoFASelectOptionStep(
        formKey: useRef(GlobalKey<FormState>()).value,
        twoFaType: TwoFaType.sms,
        onConfirm: onButtonPressed,
      ),
    );
  }
}
