// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/links_list/links_list_tile_icon.dart';
import 'package:ice/generated/assets.gen.dart';

class LinksListTile extends StatelessWidget {
  const LinksListTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.iconAssetName,
    required this.iconTintColor,
    super.key,
  });

  final String iconAssetName;
  final Color iconTintColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      onTap: onTap,
      leading: LinksListTileIcon(
        iconAssetName: iconAssetName,
        iconTintColor: iconTintColor,
      ),
      title: Text(
        title,
        style: context.theme.appTextThemes.subtitle2
            .copyWith(color: context.theme.appColors.primaryText),
      ),
      subtitle: Text(
        subtitle,
        style: context.theme.appTextThemes.caption3
            .copyWith(color: context.theme.appColors.tertararyText),
      ),
      trailing: Assets.svg.iconArrowRight.icon(
        color: context.theme.appColors.primaryText,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0.s),
      leadingPadding: EdgeInsets.only(right: 12.0.s),
      backgroundColor: Colors.transparent,
      borderRadius: BorderRadius.zero,
    );
  }
}
