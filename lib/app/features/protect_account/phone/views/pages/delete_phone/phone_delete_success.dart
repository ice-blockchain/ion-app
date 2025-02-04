// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/components/two_fa_success_step.dart';
import 'package:ion/generated/assets.gen.dart';

class PhoneDeleteSuccessPage extends ConsumerWidget {
  const PhoneDeleteSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TwoFaSuccessStep(
      iconAsset: Assets.svg.icon2faEmailVerification,
      description: context.i18n.two_fa_delete_phone_success,
    );
  }
}
