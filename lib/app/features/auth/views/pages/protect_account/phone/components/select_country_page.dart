import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SelectCountryPage extends HookWidget {
  const SelectCountryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchText = useState('');
    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    final filteredCountries = searchText.value.isEmpty
        ? countries
        : countries.where((Country country) {
            final searchLower = searchText.value.toLowerCase().trim();
            final nameLower = country.name.toLowerCase();
            final codeLower = country.isoCode.toLowerCase();
            final iddCodeLower = country.iddCode.toLowerCase();

            return nameLower.contains(searchLower) ||
                codeLower.contains(searchLower) ||
                (searchLower.startsWith('+')
                    ? iddCodeLower.contains(searchLower)
                    : iddCodeLower.contains('+$searchLower'));
          }).toList();

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.select_countries_nav_title),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                PinnedHeaderSliver(
                  child: ColoredBox(
                    color: context.theme.appColors.onPrimaryAccent,
                    child: Column(
                      children: [
                        SizedBox(height: 16.0.s),
                        ScreenSideOffset.small(
                          child: SearchInput(
                            onTextChanged: (value) => searchText.value = value,
                          ),
                        ),
                        SizedBox(height: 16.0.s),
                      ],
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final country = filteredCountries[index];
                    return GestureDetector(
                      onTap: () {
                        hideKeyboardAndCallOnce(callback: () => context.pop(country));
                      },
                      child: ScreenSideOffset.small(
                        child: SizedBox(
                          height: 40.0.s,
                          child: Row(
                            children: [
                              Text(
                                country.flag,
                                style: TextStyle(fontSize: 21.0.s),
                              ),
                              SizedBox(width: 16.0.s),
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: context.theme.appTextThemes.subtitle2.copyWith(
                                    color: context.theme.appColors.primaryText,
                                  ),
                                ),
                              ),
                              Text(
                                country.iddCode,
                                style: context.theme.appTextThemes.subtitle2.copyWith(
                                  color: context.theme.appColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 16.0.s + MediaQuery.paddingOf(context).bottom,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
