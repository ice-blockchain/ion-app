import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/select_country_return_data.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class SelectCountries extends IceSimplePage {
  const SelectCountries(super._route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
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
        children: <Widget>[
          NavigationAppBar.modal(
            title: context.i18n.select_countries_nav_title,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                FloatingAppBar(
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: filteredCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    final country = filteredCountries[index];
                    return GestureDetector(
                      onTap: () {
                        hideKeyboardAndCallOnce(
                          callback: () => context
                              .pop(SelectCountryReturnData(country: country)),
                        );
                      },
                      child: ScreenSideOffset.small(
                        child: SizedBox(
                          height: 40.0.s,
                          child: Row(
                            children: <Widget>[
                              Text(
                                country.flag,
                                style: TextStyle(fontSize: 21.0.s),
                              ),
                              SizedBox(width: UiSize.large),
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: context.theme.appTextThemes.subtitle2
                                      .copyWith(
                                    color: context.theme.appColors.primaryText,
                                  ),
                                ),
                              ),
                              Text(
                                country.iddCode,
                                style: context.theme.appTextThemes.subtitle2
                                    .copyWith(
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
                    bottom: UiSize.large + MediaQuery.paddingOf(context).bottom,
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
