// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ion/app/features/protect_account/components/twofa_initial_scaffold.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAuthenticatorInitialStep extends StatelessWidget {
  const DeleteAuthenticatorInitialStep({
    required this.onNext,
    super.key,
  });

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return TwoFaInitialScaffold(
      headerIcon: AuthHeaderIcon(
        icon: IconAsset(Assets.svgIcon2faAuthsetup, size: 36.0),
      ),
      headerTitle: locale.two_fa_option_authenticator,
      prompt: Column(
        children: [
          IconAsset(Assets.svgActionWalletGoogleauth, size: 80.0),
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
      onButtonPressed: onNext,
    );
  }
}
