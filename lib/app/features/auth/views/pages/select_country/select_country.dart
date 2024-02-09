import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';
import 'package:ice/app/shared/widgets/navigation_header/navigation_header.dart';
import 'package:ice/app/shared/widgets/search/search.dart';

class SelectCountries extends SimplePage {
  const SelectCountries(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, _, __) {
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
            const NavigationHeader(title: 'Select country'),
            Padding(
              padding: const EdgeInsets.only(top: navigationHeaderHeight),
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
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  country.flag,
                                  style: context.theme.appTextThemes.subtitle2,
                                ),
                                const SizedBox(width: 16),
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
