// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_category.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_row.dart';
import 'package:ion/app/hooks/use_selected_state.dart';

class ArticleCategoriesMenu extends HookWidget {
  const ArticleCategoriesMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final (selectedItems, toggleSelection) = useSelectedState<String>();
    final items = mockedArticleCategories;

    final firstRowItemCount = (items.length / 2).ceil();
    final firstRowItems = items.sublist(0, firstRowItemCount);
    final secondRowItems = items.sublist(firstRowItemCount);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.0.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 16.0.s),
                ArticleCategoriesRow(
                  items: firstRowItems,
                  selectedItems: selectedItems.toSet(),
                  onToggle: toggleSelection,
                  showAddButton: true,
                ),
                SizedBox(height: 10.0.s),
                ArticleCategoriesRow(
                  items: secondRowItems,
                  selectedItems: selectedItems.toSet(),
                  onToggle: toggleSelection,
                ),
              ],
            ),
          ),
        ),
        FeedListSeparator(),
      ],
    );
  }
}
