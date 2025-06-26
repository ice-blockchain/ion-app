// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/phone/models/phone_steps.dart';
import 'package:ion/app/features/protect_account/phone/views/components/phone/phone_input_step.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/request_twofa_code_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class PhoneSetupInputPage extends HookConsumerWidget {
  const PhoneSetupInputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneNumber = useRef<String?>(null);

    ref
      ..displayErrors(requestTwoFaCodeNotifierProvider)
      ..listenSuccess(requestTwoFaCodeNotifierProvider, (_) {
        if (!context.mounted) {
          return;
        }

        unawaited(
          PhoneSetupRoute(
            step: PhoneSetupSteps.confirmation,
            phone: phoneNumber.value,
          ).push<void>(context),
        );
      });

    return PhoneInputStep(
      onNext: (String phone) {
        phoneNumber.value = phone;
        ref
            .read(requestTwoFaCodeNotifierProvider.notifier)
            .requestTwoFaCode(TwoFaType.sms, value: phone);
      },
    );
  }
}
