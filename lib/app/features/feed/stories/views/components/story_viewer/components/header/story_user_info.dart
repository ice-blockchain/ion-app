// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    required this.author,
    super.key,
  });

  final String author;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              author,
              style: context.theme.appTextThemes.subtitle3
                  .copyWith(color: context.theme.appColors.onPrimaryAccent),
            ),
            SizedBox(width: 4.0.s),
            Assets.svg.iconBadgeIcelogo.icon(size: 16.0.s),
            SizedBox(width: 4.0.s),
            Assets.svg.iconBadgeCompany.icon(size: 16.0.s),
          ],
        ),
        Text(
          '@$author',
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.onPrimaryAccent),
        ),
      ],
    );
  }
}
