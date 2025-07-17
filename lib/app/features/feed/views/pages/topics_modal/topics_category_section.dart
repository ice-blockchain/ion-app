// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/features/feed/views/pages/topics_modal/components/category_header.dart';
import 'package:ion/app/features/feed/views/pages/topics_modal/components/subcategories.dart';

class TopicsCategorySection extends HookConsumerWidget {
  const TopicsCategorySection({
    required this.feedType,
    required this.category,
    this.searchQuery,
    this.addTopPadding = true,
    super.key,
  });

  final FeedType feedType;
  final String category;
  final String? searchQuery;
  final bool addTopPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableInterests = ref.watch(feedUserInterestsProvider(feedType)).valueOrNull;
    final availableCategories = availableInterests?.categories ?? {};
    final interestsCategory = availableCategories[category];
    if (interestsCategory == null) {
      return const SizedBox.shrink();
    }

    final subcategories = interestsCategory.children;
    final selected = ref.watch(
      selectedInterestsNotifierProvider.select(
        (interests) => interests.where(subcategories.containsKey).toSet(),
      ),
    );

    final filteredSubcategories = useMemoized(
      () {
        final query = searchQuery?.toLowerCase() ?? '';
        return Map.fromEntries(
          subcategories.entries.where((categoryEntry) {
            final title = categoryEntry.value.display.toLowerCase();
            return title.contains(query);
          }).toList(),
        );
      },
      [searchQuery],
    );

    if (filteredSubcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        CategoryHeader(
          categoryName: interestsCategory.display,
          addTopPadding: addTopPadding,
        ),
        Subcategories(
          subcategories: filteredSubcategories,
          onSubcategorySelected: (subcategoryKey) =>
              ref.read(selectedInterestsNotifierProvider.notifier).toggleSubcategory(
                    feedType: feedType,
                    subcategoryKey: subcategoryKey,
                  ),
          selectedSubcategories: selected,
        ),
      ],
    );
  }
}
