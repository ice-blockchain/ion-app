import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/navigation_header/navigation_header.dart';
import 'package:ice/app/components/search/search.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';

class SelectCountries extends IceSimplePage {
  const SelectCountries(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final List<Country> filteredCountries = searchText.value.isEmpty
        ? countries
        : countries.where((Country country) {
            final String searchLower = searchText.value.toLowerCase().trim();
            final String nameLower = country.name.toLowerCase();
            final String codeLower = country.isoCode.toLowerCase();
            final String iddCodeLower = country.iddCode.toLowerCase();

            return nameLower.contains(searchLower) ||
                codeLower.contains(searchLower) ||
                (searchLower.startsWith('+')
                    ? iddCodeLower.contains(searchLower)
                    : iddCodeLower.contains('+$searchLower'));
          }).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: context.theme.appColors.secondaryBackground,
        child: Stack(
          children: <Widget>[
            NavigationHeader(
              title: context.i18n.select_countries_nav_title,
            ),
            Padding(
              padding: EdgeInsets.only(top: navigationHeaderHeight),
              child: Column(
                children: <Widget>[
                  Search(
                    onTextChanged: (String value) => searchText.value = value,
                    onClearText: () => searchText.value = '',
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Country country = filteredCountries[index];
                        return InkWell(
                          onTap: context.pop,
                          child: Container(
                            height: 40.0.s,
                            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  country.flag,
                                  style: context.theme.appTextThemes.subtitle2,
                                ),
                                SizedBox(width: 16.0.s),
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
                                Text(
                                  country.iddCode,
                                  style: context.theme.appTextThemes.subtitle2
                                      .copyWith(
                                    color:
                                        context.theme.appColors.secondaryText,
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
