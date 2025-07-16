// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_interests.f.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/features/feed/views/pages/topics_modal/components/selected_topic_pill.dart';

class SelectedTopics extends HookConsumerWidget {
  const SelectedTopics({
    required this.feedType,
    required this.initialSelectedSubcategories,
    this.searchQuery,
    super.key,
  });

  final FeedType feedType;
  final Map<String, FeedInterestsSubcategory> initialSelectedSubcategories;
  final String? searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (initialSelectedSubcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final availableInterests = ref.watch(feedUserInterestsProvider(feedType)).valueOrNull;
    final availableSubcategories = availableInterests?.subcategories ?? {};
    final selected = ref.watch(
      selectedInterestsNotifierProvider.select(
        (interests) => availableSubcategories.keys.where(interests.contains).toSet(),
      ),
    );

    if (availableInterests == null || selected.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(top: 12.s, bottom: 2.s),
      child: SizedBox(
        height: 34.s,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: selected.length,
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: ScreenSideOffset.defaultSmallMargin,
          ),
          separatorBuilder: (_, __) => SizedBox(width: 8.s),
          itemBuilder: (context, index) {
            final subcategoryKey = selected.elementAt(index);
            return SelectedTopicPill(
              key: ValueKey(subcategoryKey),
              categoryName: availableSubcategories[subcategoryKey]?.display ?? subcategoryKey,
              onRemove: () =>
                  ref.read(selectedInterestsNotifierProvider.notifier).toggleSubcategory(
                        feedType: feedType,
                        subcategoryKey: subcategoryKey,
                      ),
            );
          },
        ),
      ),
    );
  }
}
