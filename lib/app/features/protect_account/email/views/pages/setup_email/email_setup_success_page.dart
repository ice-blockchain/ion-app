// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class EmailSetupSuccessPage extends StatelessWidget {
  const EmailSetupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return Column(
      children: [
        const Spacer(),
        ScreenSideOffset.medium(
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletConfirmemail,
            title: locale.common_successfully,
            description: locale.email_success_description,
          ),
        ),
        const Spacer(),
        ScreenSideOffset.large(
          child: Button(
            mainAxisSize: MainAxisSize.max,
            label: Text(locale.button_back_to_security),
            onPressed: () => SecureAccountOptionsRoute().replace(context),
          ),
        ),
      ],
    );
  }
}
