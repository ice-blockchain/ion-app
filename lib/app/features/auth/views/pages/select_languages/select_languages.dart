import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/title_description_header/title_description_header.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/language_list_item.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SelectLanguages extends IceSimplePage {
  const SelectLanguages(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<Language>> selectedLanguages =
        useState<Set<Language>>(<Language>{});

    final List<Language> filteredLanguages = searchText.value.isEmpty
        ? languages
        : languages.where((Language country) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = country.name.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          NavigationAppBar.modal(),
          TitleDescription(
            title: context.i18n.select_languages_title,
            description: context.i18n.select_languages_description,
            bottomPadding: 6.0.s,
          ),
          Expanded(
            child: ScreenSideOffset.small(
              child: CustomScrollView(
                slivers: <Widget>[
                  FloatingAppBar(
                    height: SearchInput.height,
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                    ),
                  ),
                  SliverList.builder(
                    itemCount: filteredLanguages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Language language = filteredLanguages[index];
                      final bool isSelected =
                          selectedLanguages.value.contains(language);
                      return LanguageListItem(
                        language: language,
                        isSelected: isSelected,
                        onTap: () {
                          final Set<Language> newSelectedLanguages =
                              Set<Language>.from(selectedLanguages.value);
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
