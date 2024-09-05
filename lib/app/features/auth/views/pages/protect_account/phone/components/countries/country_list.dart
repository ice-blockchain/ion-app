import 'package:flutter/material.dart';
import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/phone/components/countries/country_list_item.dart';

class CountryList extends StatelessWidget {
  const CountryList({
    super.key,
    required this.countries,
    required this.onCountrySelected,
  });

  final List<Country> countries;
  final ValueChanged<Country> onCountrySelected;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: countries.length,
      itemBuilder: (BuildContext context, int index) {
        final country = countries[index];
        return CountryListItem(
          country: country,
          onTap: () => onCountrySelected(country),
        );
      },
    );
  }
}
