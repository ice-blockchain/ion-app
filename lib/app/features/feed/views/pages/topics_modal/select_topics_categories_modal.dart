// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/feed/providers/selected_interests_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectTopicsCategoriesModal extends HookConsumerWidget {
  const SelectTopicsCategoriesModal({
    required this.feedType,
    super.key,
  });

  final FeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableInterests = ref.watch(feedUserInterestsProvider(feedType)).valueOrNull;
    final availableCategories = availableInterests?.categories ?? {};
    final availableSubcategories = availableInterests?.subcategories ?? {};
    final selectedSubcategories = ref.watch(
      selectedInterestsNotifierProvider.select(
        (interests) => interests.where(availableSubcategories.containsKey).toSet(),
      ),
    );
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final searchValue = useState('');

    final filteredTopics = useMemoized(
      () {
        final query = searchValue.value.toLowerCase();
        return Map.fromEntries(
          availableCategories.entries.where((topicEntry) {
            final title = topicEntry.value.display.toLowerCase();
            return title.contains(query);
          }),
        );
      },
      [searchValue.value],
    );

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            onBackPress: () => Navigator.pop(context, false),
            actions: [
              if (selectedSubcategories.isNotEmpty)
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.s),
                    child: Text(
                      '${context.i18n.topics_add} (${selectedSubcategories.length})',
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
                ),
            ],
            title: Text(context.i18n.topics_title),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) {
                searchValue.value = value;
              },
            ),
          ),
          SizedBox(height: 8.0.s),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTopics.length,
              itemBuilder: (BuildContext context, int index) {
                final categoryEntry = filteredTopics.entries.elementAt(index);

                return ListItem(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
                  constraints: const BoxConstraints(),
                  onTap: () => SelectTopicsSubcategoriesRoute(
                    categoryKey: categoryEntry.key,
                    feedType: feedType,
                  ).push<void>(context),
                  backgroundColor: colors.secondaryBackground,
                  trailing: Assets.svg.iconArrowRight.icon(color: colors.tertararyText),
                  title: Text(categoryEntry.value.display, style: textStyles.body),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
