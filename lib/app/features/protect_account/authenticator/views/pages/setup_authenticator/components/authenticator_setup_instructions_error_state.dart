// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class AuthenticatorSetupInstructionsErrorState extends StatelessWidget {
  const AuthenticatorSetupInstructionsErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 62.0.s),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.tertararyBackground,
                border: Border.all(color: colors.onTerararyFill),
                borderRadius: BorderRadius.circular(16.0.s),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Assets.svg.walletIconWalletLoadingerror.icon(size: 48.0.s),
                    SizedBox(height: 10.0.s),
                    Text(
                      locale.protect_account_create_recovery_error,
                      style: context.theme.appTextThemes.caption2
                          .copyWith(color: colors.onTertararyBackground),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Button(
          mainAxisSize: MainAxisSize.max,
          label: Text(locale.button_retry),
          onPressed: onRetry,
        ),
        SizedBox(height: 16.0.s),
      ],
    );
  }
}
