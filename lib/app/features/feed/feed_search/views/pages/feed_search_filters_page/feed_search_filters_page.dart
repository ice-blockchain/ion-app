// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/feed_search/providers/feed_search_filters_provider.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_search_filters_page/feed_search_filter_languages_section.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_search_filters_page/feed_search_filter_people_section.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class FeedSearchFiltersPage extends HookConsumerWidget {
  const FeedSearchFiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(feedSearchFilterProvider);
    final filterLocalState = useState(filterState);
    final hasChanges = filterLocalState.value != filterState;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.feed_search_filter_title),
            actions: [
              NavigationTextButton(
                label: context.i18n.button_reset,
                onPressed: () {
                  filterLocalState.value = FeedSearchFiltersState.initial();
                },
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: Column(
              children: [
                SizedBox(height: 8.0.s),
                FeedSearchFilterPeopleSection(
                  selectedFilter: filterLocalState.value.people,
                  onFilterChange: (peopleFilter) {
                    filterLocalState.value = filterLocalState.value.copyWith(people: peopleFilter);
                  },
                ),
                SizedBox(height: 18.0.s),
                FeedSearchFilterLanguagesSection(
                  selectedLanguages: filterLocalState.value.languages,
                  onFilterChange: (languages) {
                    filterLocalState.value = filterLocalState.value.copyWith(languages: languages);
                  },
                ),
                SizedBox(height: 34.0.s),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0.s),
                  child: Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text(context.i18n.button_apply),
                    type: hasChanges ? ButtonType.primary : ButtonType.disabled,
                    disabled: !hasChanges,
                    onPressed: () {
                      ref.read(feedSearchFilterProvider.notifier).newState = filterLocalState.value;
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}
