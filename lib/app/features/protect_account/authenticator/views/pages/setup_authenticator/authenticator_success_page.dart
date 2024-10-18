// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class AuthenticatorSuccessPage extends StatelessWidget {
  const AuthenticatorSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScreenSideOffset.medium(
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletGoogleauth,
            title: context.i18n.recovery_keys_successfully_protected_title,
            description: context.i18n.authenticator_protected_description,
          ),
        ),
      ],
    );
  }
}
