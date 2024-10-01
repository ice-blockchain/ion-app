// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu_container.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_menu/post_menu_item.dart';
import 'package:ice/generated/assets.gen.dart';

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
      child: SizedBox(
        width: 48.0.s,
        height: 48.0.s,
        child: Transform(
          transform: Matrix4.translationValues(12.0.s, 0, 0),
          child: IconButton(
            onPressed: null,
            icon: Assets.svg.iconMorePopup.icon(
              color: context.theme.appColors.onTertararyBackground,
            ),
          ),
        ),
      ),
    );
  }
}
