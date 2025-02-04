// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/components/two_fa_success_step.dart';
import 'package:ion/generated/assets.gen.dart';

class PhoneEditSuccessPage extends StatelessWidget {
  const PhoneEditSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TwoFaSuccessStep(
      iconAsset: Assets.svg.actionWalletConfirmphone,
      description: context.i18n.two_fa_edit_phone_success,
    );
  }
}
