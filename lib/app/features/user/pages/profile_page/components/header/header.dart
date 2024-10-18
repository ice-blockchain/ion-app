// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ice/app/features/user/pages/profile_page/components/header/context_menu.dart';
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
                Navigator.of(context).pop(true);
              },
              assetName: Assets.svg.iconChatBack,
            ),
            const Spacer(),
            const ContextMenu(),
          ],
        ),
      ),
    );
  }
}
