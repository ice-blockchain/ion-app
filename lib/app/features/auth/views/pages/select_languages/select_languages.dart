import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/language_list_item.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';
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

    final bool mayContinue = selectedLanguages.value.isNotEmpty;

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          AuthHeader(
            title: context.i18n.select_languages_title,
            description: context.i18n.select_languages_description,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                FloatingAppBar(
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
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s +
                        (mayContinue
                            ? 0
                            : MediaQuery.paddingOf(context).bottom),
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
                    FocusManager.instance.primaryFocus?.unfocus();
                    IceRoutes.discoverCreators.push(context);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
