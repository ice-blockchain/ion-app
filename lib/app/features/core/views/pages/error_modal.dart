// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ErrorModal extends StatelessWidget {
  const ErrorModal({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30.0.s, right: 30.0.s, top: 30.0.s),
          child: InfoCard(
            iconAsset: Assets.svg.actionWalletKeyserror,
            title: context.i18n.error_general_title,
            description: error.toString(),
          ),
        ),
        SizedBox(height: 24.0.s),
        ScreenSideOffset.small(
          child: Button(
            label: Text(context.i18n.button_try_again),
            mainAxisSize: MainAxisSize.max,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
