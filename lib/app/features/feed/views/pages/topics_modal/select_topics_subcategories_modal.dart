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
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SelectTopicsSubcategoriesModal extends HookConsumerWidget {
  const SelectTopicsSubcategoriesModal({
    required this.categoryKey,
    required this.feedType,
    super.key,
  });

  final String categoryKey;
  final FeedType feedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCategories =
        ref.watch(feedUserInterestsProvider(feedType)).valueOrNull?.categories ?? {};
    final subcategories = availableCategories[categoryKey]?.children ?? {};
    final selectedSubcategories = ref.watch(
      selectedInterestsNotifierProvider.select(
        (interests) => interests.where(subcategories.containsKey).toSet(),
      ),
    );
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;
    final searchValue = useState('');

    final filteredSubcategories = useMemoized(
      () {
        final query = searchValue.value.toLowerCase();
        return subcategories.entries.where((categoryEntry) {
          final title = categoryEntry.value.display.toLowerCase();
          return title.contains(query);
        }).toList();
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
              itemCount: filteredSubcategories.length,
              itemBuilder: (BuildContext context, int index) {
                final subcategory = filteredSubcategories[index];
                final isSelected = selectedSubcategories.contains(subcategory.key);

                return ListItem(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 8.0.s),
                  constraints: const BoxConstraints(),
                  onTap: () => _toggleTopicSelection(
                    ref,
                    selectedSubcategories,
                    subcategory.key,
                  ),
                  backgroundColor: colors.secondaryBackground,
                  trailing: isSelected
                      ? Assets.svg.iconBlockCheckboxOnblue.icon(color: colors.success)
                      : Assets.svg.iconBlockCheckboxOff.icon(color: colors.tertararyText),
                  title: Text(subcategory.value.display, style: textStyles.body),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTopicSelection(
    WidgetRef ref,
    Set<String> currentCategorySelectedSubcategories,
    String subcategoryKey,
  ) {
    final selectedSubcategories = ref.read(selectedInterestsNotifierProvider);
    final notifier = ref.read(selectedInterestsNotifierProvider.notifier);
    if (selectedSubcategories.contains(subcategoryKey)) {
      notifier.selectInterests = Set.from(selectedSubcategories)..remove(subcategoryKey);
      final newCurrentCategorySelectedSubcategories =
          Set<String>.from(currentCategorySelectedSubcategories)..remove(subcategoryKey);
      if (newCurrentCategorySelectedSubcategories.isEmpty) {
        notifier.selectInterests = Set.from(selectedSubcategories)
          ..removeAll([subcategoryKey, categoryKey]);
      }
    } else {
      notifier.selectInterests = Set.from(selectedSubcategories)
        ..addAll([subcategoryKey, categoryKey]);
    }
  }
}
