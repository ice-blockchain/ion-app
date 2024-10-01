// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/model/language.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_search_languages_page/feed_search_language_list_item.dart';
import 'package:ice/app/hooks/use_languages.dart';
import 'package:ice/app/hooks/use_selected_state.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class FeedSearchLanguagesPage extends HookWidget {
  const FeedSearchLanguagesPage({
    required this.defaultSelected,
    super.key,
  });

  final List<Language> defaultSelected;

  @override
  Widget build(BuildContext context) {
    final (selectedLanguages, toggleLanguageSelection) =
        useSelectedState<Language>(defaultSelected);
    final searchQuery = useState('');
    final languages = useLanguages(query: searchQuery.value);

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.common_select_languages),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) => searchQuery.value = value,
            ),
          ),
          SizedBox(height: 14.0.s),
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (BuildContext context, int index) {
                final language = languages[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => toggleLanguageSelection(language),
                  child: FeedSearchLanguageListItem(
                    language: language,
                    selected: selectedLanguages.contains(language),
                  ),
                );
              },
            ),
          ),
          if (selectedLanguages.isNotEmpty) ...[
            SizedBox(height: 10.0.s),
            const HorizontalSeparator(),
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0.s),
                child: Button(
                  label: Text(context.i18n.button_apply),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () => context.pop(selectedLanguages),
                ),
              ),
            ),
          ],
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
