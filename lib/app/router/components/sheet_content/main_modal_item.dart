// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/model/main_modal_list_item.dart';

class MainModalItem extends StatelessWidget {
  const MainModalItem({
    required this.item,
    required this.onTap,
    required this.index,
    super.key,
  });

  final MainModalListItem item;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      contentPadding: EdgeInsetsDirectional.fromSTEB(
        40.0.s,
        index == 0 ? 9.0.s : 12.0.s,
        40.0.s,
        12.0.s,
      ),
      constraints: BoxConstraints(
        minHeight: 42.0.s,
      ),
      leadingPadding: EdgeInsetsDirectional.only(end: 10.0.s),
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
        maxLines: 2,
      ),
      leading: Container(
        width: 42.0.s,
        height: 42.0.s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: item.getIconColor(context),
        ),
        child: Center(
          child: item.iconAsset.icon(size: 24.0.s, color: context.theme.appColors.onPrimaryAccent),
        ),
      ),
      backgroundColor: Colors.transparent,
      onTap: onTap,
    );
  }
}
