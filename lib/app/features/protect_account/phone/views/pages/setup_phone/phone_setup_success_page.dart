// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/generated/assets.gen.dart';

class PhoneSetupSuccessPage extends StatelessWidget {
  const PhoneSetupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScreenSideOffset.medium(
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletConfirmphone,
            title: locale.common_successfully,
            description: locale.phone_success_description,
          ),
        ),
        SizedBox(
          height: 22.0.s,
        ),
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
