// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/components/twofa_select_options_step.dart';
import 'package:ion/app/features/protect_account/components/twofa_step_scaffold.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';

class PhoneEditTwoFaOptionsStep extends HookWidget {
  const PhoneEditTwoFaOptionsStep({
    required this.onNext,
    required this.onPrevious,
    super.key,
  });

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return TwoFAStepScaffold(
      headerIcon: const IconAsset(Assets.svgIcon2faPhoneconfirm, size: 36.0),
      headerTitle: locale.two_fa_edit_phone_title,
      headerDescription: locale.two_fa_edit_phone_options_description,
      onBackPress: onPrevious,
      child: TwoFASelectOptionStep(
        formKey: useRef(GlobalKey<FormState>()).value,
        twoFaType: TwoFaType.email,
        onConfirm: onNext,
      ),
    );
  }
}
