// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class DescriptionListItem extends StatelessWidget {
  const DescriptionListItem({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.large(
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0.s),
                child: icon,
              ),
            ],
          ),
          Expanded(
            child: Text(
              title,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
