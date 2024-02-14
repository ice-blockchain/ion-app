import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/navigation_header/navigation_header.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/search/search.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/title_description_header/title_description_header.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/generated/assets.gen.dart';

class SelectLanguages extends IceSimplePage {
  const SelectLanguages(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final ValueNotifier<Set<Language>> selectedLanguagesNotifier =
        useState<Set<Language>>(<Language>{});
    final Set<Language> selectedLanguages = selectedLanguagesNotifier.value;

    final List<Language> filteredLanguages = searchText.value.isEmpty
        ? languages
        : languages.where((Language country) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = country.name.toLowerCase();
            return nameLower.contains(searchLower);
          }).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            const NavigationHeader(title: ''),
            ScreenSideOffset.small(
              child: Padding(
                padding: EdgeInsets.only(
                  top: navigationHeaderHeight,
                ),
                child: Column(
                  children: <Widget>[
                    TitleDescription(
                      title: context.i18n.select_languages_title,
                      description: context.i18n.select_languages_description,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0.s),
                      child: Search(
                        onTextChanged: (String value) =>
                            searchText.value = value,
                        onClearText: () {
                          searchText.value = '';
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredLanguages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Language country = filteredLanguages[index];
                          final bool isSelected =
                              selectedLanguages.contains(country);

                          return InkWell(
                            onTap: () {
                              final Set<Language> newSelectedLanguages =
                                  Set<Language>.from(selectedLanguages);
                              if (isSelected) {
                                newSelectedLanguages.remove(country);
                              } else {
                                newSelectedLanguages.add(country);
                              }
                              selectedLanguagesNotifier.value =
                                  newSelectedLanguages;
                            },
                            child: Container(
                              height: 44.0.s,
                              decoration: BoxDecoration(
                                color:
                                    context.theme.appColors.tertararyBackground,
                                borderRadius: BorderRadius.circular(12.0.s),
                              ),
                              margin: EdgeInsets.only(
                                bottom: 12.0.s,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0.s,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    country.flag,
                                    style: context.theme.appTextThemes.subtitle2
                                        .copyWith(
                                      color:
                                          context.theme.appColors.primaryText,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0.s,
                                  ),
                                  Expanded(
                                    child: Text(
                                      country.name,
                                      style: context
                                          .theme.appTextThemes.subtitle2
                                          .copyWith(
                                        color:
                                            context.theme.appColors.primaryText,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.0.s,
                                    child: isSelected
                                        ? Image.asset(
                                            Assets.images.icons
                                                .iconBlockCheckboxOn.path,
                                          )
                                        : Image.asset(
                                            Assets.images.icons
                                                .iconBlockCheckboxOff.path,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
