// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class LaunchDappButton extends StatelessWidget {
  const LaunchDappButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: 16.0.s,
          bottom: 36.0.s,
        ),
        child: Button(
          mainAxisSize: MainAxisSize.max,
          label: Text(
            context.i18n.dapp_details_launch_dapp_button_title,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
