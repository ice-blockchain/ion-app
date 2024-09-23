import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/article_category.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_row.dart';

class ArticleCategoriesMenu extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedItems = useState<Set<String>>({});
    final List<ArticleCategory> items = mockedArticleCategories;

    final firstRowItemCount = (items.length / 2).ceil();
    final firstRowItems = items.sublist(0, firstRowItemCount);
    final secondRowItems = items.sublist(firstRowItemCount);

    final toggleSelection = useCallback((String id) {
      final newSelected = Set<String>.from(selectedItems.value);

      newSelected.contains(id) ? newSelected.remove(id) : newSelected.add(id);

      selectedItems.value = newSelected;
    }, [selectedItems.value]);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 16.0.s),
            ArticleCategoriesRow(
              items: firstRowItems,
              selectedItems: selectedItems.value,
              onToggle: toggleSelection,
              showAddButton: true,
            ),
            SizedBox(height: 10.0.s),
            ArticleCategoriesRow(
              items: secondRowItems,
              selectedItems: selectedItems.value,
              onToggle: toggleSelection,
            ),
          ],
        ),
      ),
    );
  }
}
