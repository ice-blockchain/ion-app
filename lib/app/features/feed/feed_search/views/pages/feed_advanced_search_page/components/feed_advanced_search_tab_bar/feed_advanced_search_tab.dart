// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_advanced_search_category.dart';

class FeedAdvancedSearchTab extends StatelessWidget {
  const FeedAdvancedSearchTab({required this.category, super.key});

  final FeedAdvancedSearchCategory category;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return Padding(
      padding: EdgeInsets.only(bottom: 11.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          category.icon(context).icon(size: 18.0.s, color: color),
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
