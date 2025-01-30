// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/common/two_fa_utils.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/phone/views/components/phone/phone_input_step.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

class PhoneSetupInputPage extends HookConsumerWidget {
  const PhoneSetupInputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PhoneInputStep(
      onNext: (String phoneNumber) async {
        await requestTwoFACode(
          ref,
          TwoFAType.sms(phoneNumber),
        );

        if (!context.mounted) {
          return;
        }

        unawaited(
          PhoneSetupRoute(
            step: PhoneSetupSteps.confirmation,
            phone: phoneNumber,
          ).push<void>(context),
        );
      },
    );
  }
}
