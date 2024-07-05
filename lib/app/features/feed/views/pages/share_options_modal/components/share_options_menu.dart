import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/shadow/shadow_container/shadow_container.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/share_options_menu_item.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareOptionsMenu extends StatelessWidget {
  const ShareOptionsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBoxShadow(
      child: ColoredBox(
        color: context.theme.appColors.secondaryBackground,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0.s, top: 20.0.s, bottom: 16.0.s),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ShareOptionsMenuItem(
                  buttonType: ButtonType.primary,
                  icon: Assets.images.icons.iconFeedStories.icon(),
                  label: context.i18n.feed_add_story,
                  onPressed: () {},
                ),
                SizedBox(width: 12.0.s),
                ShareOptionsMenuItem(
                  buttonType: ButtonType.dropdown,
                  icon: Assets.images.icons.iconBlockCopy1
                      .icon(color: Colors.black),
                  label: context.i18n.feed_copy_link,
                  onPressed: () {},
                ),
                SizedBox(width: 12.0.s),
                ShareOptionsMenuItem(
                  buttonType: ButtonType.dropdown,
                  icon: Assets.images.icons.iconBookmarks
                      .icon(color: Colors.black),
                  label: context.i18n.feed_bookmark,
                  onPressed: () {},
                ),
                SizedBox(width: 12.0.s),
                ShareOptionsMenuItem(
                  buttonType: ButtonType.dropdown,
                  icon: Assets.images.icons.iconFeedWhatsapp.icon(),
                  label: context.i18n.feed_whatsapp,
                  onPressed: () {},
                ),
                SizedBox(width: 12.0.s),
                ShareOptionsMenuItem(
                  buttonType: ButtonType.dropdown,
                  icon: Assets.images.icons.iconFeedMore.icon(),
                  label: context.i18n.feed_more,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
