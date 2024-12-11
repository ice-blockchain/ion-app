// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/delete_twofa_initial_scaffold.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAuthenticatorInitialStep extends StatelessWidget {
  const DeleteAuthenticatorInitialStep({
    required this.onButtonPressed,
    super.key,
  });

  final VoidCallback onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return DeleteTwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: Assets.svg.icon2faAuthsetup.icon(size: 36.0.s),
      ),
      headerTitle: locale.two_fa_option_authenticator,
      prompt: Column(
        children: [
          Assets.svg.actionWalletGoogleauth.icon(size: 80.0.s),
          SizedBox(height: 20.0.s),
          Text(
            locale.authenticator_is_linked_to_account,
            textAlign: TextAlign.center,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
          ),
        ],
      ),
      buttonLabel: locale.button_delete,
      onButtonPressed: onButtonPressed,
    );
  }
}
