// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/model/main_modal_list_item.dart';

class MainModalItem extends StatelessWidget {
  const MainModalItem({
    required this.item,
    required this.onTap,
    super.key,
  });

  final MainModalListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.only(top: 2.0.s, bottom: 1.0.s),
        child: ListItem(
          title: Text(
            item.getDisplayName(context),
            style: context.theme.appTextThemes.subtitle2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
          subtitle: Text(
            item.getDescription(context),
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 12.0.s),
            child: Container(
              width: 42.0.s,
              height: 42.0.s,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: item.getIconColor(context),
              ),
              child: Center(
                child: item.iconAsset
                    .icon(size: 24.0.s, color: context.theme.appColors.onPrimaryAccent),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          onTap: onTap,
        ),
      ),
    );
  }
}
