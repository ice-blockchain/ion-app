import 'package:flutter/material.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/decorations.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/links_list/links_list_tile.dart';
import 'package:ice/generated/assets.gen.dart';

class LinksList extends StatelessWidget {
  const LinksList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40.0.s),
      padding: EdgeInsets.symmetric(horizontal: 30.0.s, vertical: 6.0.s),
      decoration: Decorations.borderBoxDecoration(context),
      child: SeparatedColumn(
        separator: HorizontalSeparator(),
        children: [
          LinksListTile(
            iconAssetName: Assets.svg.iconProfileUser,
            iconTintColor: context.theme.appColors.orangePeel,
            title: context.i18n.profile_profile,
            subtitle: context.i18n.profile_profile_desc,
            onTap: () {},
          ),
          LinksListTile(
            iconAssetName: Assets.svg.iconProfileFeed,
            iconTintColor: context.theme.appColors.purple,
            title: context.i18n.general_feed,
            subtitle: context.i18n.profile_feed_desc,
            onTap: () {},
          ),
          LinksListTile(
            iconAssetName: Assets.svg.iconVideosTrading,
            iconTintColor: context.theme.appColors.raspberry,
            title: context.i18n.general_videos,
            subtitle: context.i18n.profile_videos_desc,
            onTap: () {},
          ),
          LinksListTile(
            iconAssetName: Assets.svg.iconFeedStories,
            iconTintColor: context.theme.appColors.success,
            title: context.i18n.general_articles,
            subtitle: context.i18n.profile_articles_desc,
            onTap: () {},
          ),
          LinksListTile(
            iconAssetName: Assets.svg.iconBookmarks,
            iconTintColor: context.theme.appColors.primaryAccent,
            title: context.i18n.profile_bookmarks,
            subtitle: context.i18n.profile_bookmarks_desc,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
