// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTopOffset(
      child: ScreenSideOffset.small(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAction(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              assetName: Assets.svg.iconProfileBack,
            ),
            const Spacer(),
            HeaderAction(
              onPressed: () {},
              assetName: Assets.svg.iconChatDarkmode,
            ),
            SizedBox(width: 12.0.s),
            HeaderAction(
              onPressed: () {
                SwitchAccountRoute().push<void>(context);
              },
              assetName: Assets.svg.iconSwitchProfile,
            ),
          ],
        ),
      ),
    );
  }
}
