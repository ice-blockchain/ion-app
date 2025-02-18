// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class TwoFaSuccessStep extends StatelessWidget {
  const TwoFaSuccessStep({
    required this.iconAsset,
    required this.description,
    super.key,
  });

  final String iconAsset;
  final String description;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 45.0.s,
          ),
          ScreenSideOffset.medium(
            child: InfoCard(
              iconAsset: iconAsset,
              title: locale.common_congratulations,
              description: description,
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
          ScreenBottomOffset(margin: 16.0.s),
        ],
      ),
    );
  }
}
