// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/header/header_action.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

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
                FeedRoute().go(context);
              },
              assetName: Assets.svg.iconChatBack,
            ),
            const Spacer(),
            HeaderAction(
              onPressed: () {},
              assetName: Assets.svg.iconChatDarkmode,
            ),
            SizedBox(width: 12.0.s),
            HeaderAction(
              onPressed: () {
                SwitchAccountRoute().go(context);
              },
              assetName: Assets.svg.iconSwitchProfile,
            ),
          ],
        ),
      ),
    );
  }
}
