// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';

class AdvancedSearchTab extends StatelessWidget {
  const AdvancedSearchTab({required this.category, super.key});

  final AdvancedSearchCategory category;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 11.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconAssetColored(category.icon(context), size: 18, color: color!),
          SizedBox(width: 6.0.s),
          Text(
            category.label(context),
            style: context.theme.appTextThemes.subtitle3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
