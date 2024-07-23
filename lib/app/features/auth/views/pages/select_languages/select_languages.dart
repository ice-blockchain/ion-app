import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/language_list_item.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SelectLanguages extends HookWidget {
  const SelectLanguages({super.key});

  @override
  Widget build(BuildContext context) {
    final searchText = useState('');

    final selectedLanguages = useState<Set<Language>>(<Language>{});

    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    final filteredLanguages = searchText.value.isEmpty
        ? languages
        : languages.where((Language country) {
            final searchLower = searchText.value.toLowerCase().trim();
            final nameLower = country.name.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();

    final mayContinue = selectedLanguages.value.isNotEmpty;

    return SheetContent(
      body: Column(
        children: [
          AuthHeader(
            title: context.i18n.select_languages_title,
            description: context.i18n.select_languages_description,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                CollapsingAppBar(
                  topOffset: 16.0.s,
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                    ),
                  ),
                ),
                SliverList.separated(
                  itemCount: filteredLanguages.length,
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 12.0.s,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final language = filteredLanguages[index];
                    final isSelected = selectedLanguages.value.contains(language);
                    return LanguageListItem(
                      language: language,
                      isSelected: isSelected,
                      onTap: () {
                        final newSelectedLanguages = Set<Language>.from(selectedLanguages.value);
                        if (isSelected) {
                          newSelectedLanguages.remove(language);
                        } else {
                          newSelectedLanguages.add(language);
                        }
                        selectedLanguages.value = newSelectedLanguages;
                      },
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + (mayContinue ? 0 : MediaQuery.paddingOf(context).bottom),
                  ),
                ),
              ],
            ),
          ),
          if (mayContinue)
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8.0.s,
                  bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                ),
                child: Button(
                  label: Text(context.i18n.button_continue),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: () {
                    hideKeyboardAndCallOnce(
                      callback: () => DiscoverCreatorsRoute().push<void>(context),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
