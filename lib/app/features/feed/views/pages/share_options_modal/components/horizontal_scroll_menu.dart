import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/share_options_modal/components/scroll_menu_item.dart';
import 'package:ice/generated/assets.gen.dart';

class HorizontalScrollMenu extends StatelessWidget {
  const HorizontalScrollMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.strokeElements.withOpacity(0.5),
            offset: Offset(0.0.s, -1.0.s),
            blurRadius: 5.0.s,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0.s, top: 20.0.s, bottom: 16.0.s),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ScrollMenuItem(
                buttonType: ButtonType.primary,
                icon: Assets.images.icons.iconFeedStories.icon(),
                label: context.i18n.feed_add_story,
                onPressed: () {},
              ),
              SizedBox(width: 12.0.s),
              ScrollMenuItem(
                buttonType: ButtonType.dropdown,
                icon: Assets.images.icons.iconBlockCopy1
                    .icon(color: Colors.black),
                label: context.i18n.feed_copy_link,
                onPressed: () {},
              ),
              SizedBox(width: 12.0.s),
              ScrollMenuItem(
                buttonType: ButtonType.dropdown,
                icon:
                    Assets.images.icons.iconBookmarks.icon(color: Colors.black),
                label: context.i18n.feed_bookmark,
                onPressed: () {},
              ),
              SizedBox(width: 12.0.s),
              ScrollMenuItem(
                buttonType: ButtonType.dropdown,
                icon: Assets.images.icons.iconFeedWhatsapp.icon(),
                label: context.i18n.feed_whatsapp,
                onPressed: () {},
              ),
              SizedBox(width: 12.0.s),
              ScrollMenuItem(
                buttonType: ButtonType.dropdown,
                icon: Assets.images.icons.iconFeedMore.icon(),
                label: context.i18n.feed_more,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
