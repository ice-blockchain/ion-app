// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu.dart';
import 'package:ion/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_menu/post_menu_item.dart';
import 'package:ion/generated/assets.gen.dart';

class PostMenu extends StatelessWidget {
  const PostMenu({super.key});

  static double get iconSize => 20.0.s;

  @override
  Widget build(BuildContext context) {
    return OverlayMenu(
      offset: Offset(-146.0.s, 0),
      menuBuilder: (closeMenu) => Column(
        children: [
          OverlayMenuContainer(
            child: PostMenuItem(
              label: context.i18n.post_menu_not_interested,
              icon: Assets.svg.iconNotinterested.icon(size: iconSize),
              onPressed: closeMenu,
            ),
          ),
          SizedBox(height: 14.0.s),
          OverlayMenuContainer(
            child: Column(
              children: [
                PostMenuItem(
                  label: context.i18n.post_menu_follow_nickname('nickname'),
                  icon: Assets.svg.iconFollowuser.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
                PostMenuItem(
                  label: context.i18n.post_menu_block_nickname('nickname'),
                  icon: Assets.svg.iconBlock.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
                PostMenuItem(
                  label: context.i18n.post_menu_report_post,
                  icon: Assets.svg.iconReport.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
              ],
            ),
          ),
        ],
      ),
      child: Assets.svg.iconMorePopup.icon(
        color: context.theme.appColors.onTertararyBackground,
      ),
    );
  }
}
