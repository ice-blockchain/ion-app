// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/components/two_fa_edit_new_value_confirmation_step.dart';
import 'package:ion/app/features/protect_account/components/twofa_step_scaffold.dart';
import 'package:ion/app/utils/formatters.dart';
import 'package:ion/generated/assets.gen.dart';

class EmailEditConfirmNewEmailStep extends HookConsumerWidget {
  const EmailEditConfirmNewEmailStep({
    required this.email,
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final String email;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return TwoFAStepScaffold(
      headerTitle: locale.two_fa_edit_email_title,
      headerDescription: locale.two_fa_code_confirmation,
      headerIcon: const IconAsset(Assets.svgIcon2faEmailauth, size: 36),
      onBackPress: onPrevious,
      contentPadding: 0,
      child: TwoFaEditConfirmNewValueStep(
        newValue: obscureEmail(email),
        twoFaType: TwoFaType.email,
        onNext: onNext,
      ),
    );
  }
}
