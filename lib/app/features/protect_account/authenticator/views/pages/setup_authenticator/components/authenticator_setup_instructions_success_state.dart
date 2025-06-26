// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/warning_card.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/protect_account/authenticator/views/components/copy_key_card.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class AuthenticatorSetupInstructionsSuccessState extends StatelessWidget {
  const AuthenticatorSetupInstructionsSuccessState({required this.code, super.key});

  final String? code;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              CopyKeyCard(code: code),
              const Spacer(),
              WarningCard(text: locale.warning_authenticator_setup),
            ],
          ),
        ),
        SizedBox(height: 22.0.s),
        Button(
          mainAxisSize: MainAxisSize.max,
          type: code == null ? ButtonType.disabled : ButtonType.primary,
          label: Text(context.i18n.button_next),
          onPressed: () => AuthenticatorSetupCodeConfirmRoute().push<void>(context),
        ),
      ],
    );
  }
}
