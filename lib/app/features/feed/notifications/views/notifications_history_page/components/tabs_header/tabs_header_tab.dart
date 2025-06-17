// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_tab_type.dart';

class NotificationsHistoryTab extends StatelessWidget {
  const NotificationsHistoryTab({
    required this.tabType,
    super.key,
  });

  final NotificationsTabType tabType;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconAssetColored(tabType.iconAsset, size: 18.0, color: color!),
          SizedBox(width: 6.0.s),
          Text(
            tabType.getTitle(context),
            style: context.theme.appTextThemes.subtitle3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
