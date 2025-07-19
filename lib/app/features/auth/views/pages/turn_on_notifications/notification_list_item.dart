// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    required this.title,
    required this.description,
    required this.time,
    required this.image,
    this.iceVerified,
    super.key,
  });

  final String title;
  final String description;
  final String time;
  final Widget image;
  final bool? iceVerified;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 43.0.s),
      child: ListItem(
        crossAxisAlignment: CrossAxisAlignment.start,
        // that is a mock notification
        title: Text(
          title,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.secondaryBackground,
          ),
        ),
        subtitle: Text(
          description,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.secondaryBackground,
          ),
        ),
        leading: image,
        backgroundColor: context.theme.appColors.primaryAccent,
        contentPadding: EdgeInsets.all(12.0.s),
        borderRadius: BorderRadius.circular(16.0.s),
        trailing: Text(
          time,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.tertararyBackground,
          ),
        ),
        trailingPadding: EdgeInsetsDirectional.only(start: 6.0.s),
      ),
    );
  }
}
