import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_languages/languages.dart';
import 'package:ice/app/shared/widgets/navigation_header/navigation_header.dart';
import 'package:ice/app/shared/widgets/search/search.dart';
import 'package:ice/app/shared/widgets/title_description_header/title_description_header.dart';
import 'package:ice/app/values/constants.dart';
import 'package:ice/generated/assets.gen.dart';

class SelectLanguages extends HookConsumerWidget {
  const SelectLanguages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<String> searchText = useState('');
    final Set<Language> selectedLanguages =
        useState<Set<Language>>(<Language>{}).value;

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
            Padding(
              padding: const EdgeInsets.only(
                top: navigationHeaderHeight,
                left: kDefaultSidePadding,
                right: kDefaultSidePadding,
              ),
              child: Column(
                children: <Widget>[
                  const TitleDescription(
                    title: 'Select languages',
                    description:
                        'You’ll be shown content in the selected language',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Search(
                      onTextChanged: (String value) => searchText.value = value,
                      onClearText: () {
                        searchText.value = '';
                        selectedLanguages.clear();
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
                            if (isSelected) {
                              selectedLanguages.remove(country); // Deselect
                            } else {
                              selectedLanguages.add(country); // Select
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color:
                                  context.theme.appColors.tertararyBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultSidePadding,
                            ),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  country.flag,
                                  style: context.theme.appTextThemes.subtitle2
                                      .copyWith(
                                    color: context.theme.appColors.primaryText,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ), // Space between flag and name
                                Expanded(
                                  child: Text(
                                    country.name,
                                    style: context.theme.appTextThemes.subtitle2
                                        .copyWith(
                                      color:
                                          context.theme.appColors.primaryText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30, // Adjust as needed
                                  child: isSelected
                                      ? Image.asset(
                                          Assets.images.checkboxon.path,
                                        )
                                      : Image.asset(
                                          Assets.images.checkboxoff.path,
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
          ],
        ),
      ),
    );
  }
}
