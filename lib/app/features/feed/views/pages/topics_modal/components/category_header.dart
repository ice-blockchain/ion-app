// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class CategoryHeader extends StatelessWidget {
  const CategoryHeader({
    required this.categoryName,
    required this.addTopPadding,
    super.key,
  });

  final String categoryName;
  final bool addTopPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16.s,
        end: 25.s,
        top: addTopPadding ? 16.s : 2.s,
        bottom: 6.s,
      ),
      child: Text(
        categoryName.toUpperCase(),
        style: context.theme.appTextThemes.caption6.copyWith(
          color: context.theme.appColors.tertiaryText,
        ),
      ),
    );
  }
}
