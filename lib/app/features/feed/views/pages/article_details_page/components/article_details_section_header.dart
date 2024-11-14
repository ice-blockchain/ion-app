// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ArticleDetailsSectionHeader extends StatelessWidget {
  const ArticleDetailsSectionHeader({
    required this.title,
    this.count,
    this.trailing,
    super.key,
  });

  final String title;
  final int? count;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.theme.appTextThemes.subtitle.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        SizedBox(width: 4.0.s),
        if (count != null && count! > 0)
          Text(
            '($count)',
            style: context.theme.appTextThemes.subtitle.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
