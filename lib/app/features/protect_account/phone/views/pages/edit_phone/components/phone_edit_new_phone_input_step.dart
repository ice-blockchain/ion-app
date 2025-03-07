// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/components/twofa_step_scaffold.dart';
import 'package:ion/app/features/protect_account/phone/views/components/phone/phone_input_step.dart';
import 'package:ion/generated/assets.gen.dart';

class PhoneEditNewPhoneInputStep extends HookConsumerWidget {
  const PhoneEditNewPhoneInputStep({required this.onNext, super.key});

  final void Function(String phone) onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    return TwoFAStepScaffold(
      headerIcon: Assets.svg.icon2faPhoneconfirm.icon(size: 36.0.s),
      headerTitle: locale.two_fa_edit_phone_title,
      headerDescription: locale.two_fa_edit_phone_new_phone_description,
      contentPadding: 0,
      bottomPadding: ScreenBottomOffset.defaultMargin,
      child: PhoneInputStep(onNext: onNext),
    );
  }
}
