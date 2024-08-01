import 'package:flutter/material.dart';
import 'package:ice/app/components/overlay_menu/overlay_menu.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_menu/post_menu_container.dart';
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
          PostMenuContainer(
            child: PostMenuItem(
              label: context.i18n.post_menu_not_interested,
              icon: Assets.images.icons.iconNotinterested.icon(size: iconSize),
              onPressed: closeMenu,
            ),
          ),
          SizedBox(height: 14.0.s),
          PostMenuContainer(
            child: Column(
              children: [
                PostMenuItem(
                  label: context.i18n.post_menu_follow_nickname('nickname'),
                  icon: Assets.images.icons.iconFollowuser.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
                PostMenuItem(
                  label: context.i18n.post_menu_block_nickname('nickname'),
                  icon: Assets.images.icons.iconBlock.icon(size: iconSize),
                  onPressed: closeMenu,
                ),
                PostMenuItem(
                  label: context.i18n.post_menu_report_post,
                  icon: Assets.images.icons.iconReport.icon(size: iconSize),
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
            icon: Assets.images.icons.iconMorePopup.icon(
              color: context.theme.appColors.onTertararyBackground,
            ),
          ),
        ),
      ),
    );
  }
}
