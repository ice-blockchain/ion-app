// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class SearchSubHeader extends StatelessWidget {
  const SearchSubHeader({required this.icon, required this.title, required this.count, super.key});

  final String icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconAssetColored(
            icon,
            size: 16,
            color: context.theme.appColors.primaryText,
          ),
          SizedBox(width: 6.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.body2,
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: context.theme.appTextThemes.body2,
          ),
          SizedBox(width: 6.0.s),
        ],
      ),
    );
  }
}
