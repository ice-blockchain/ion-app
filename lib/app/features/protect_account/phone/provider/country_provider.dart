import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_provider.g.dart';

@riverpod
List<Country> countries(CountriesRef ref) => countriesData;

@riverpod
class SelectedCountry extends _$SelectedCountry {
  @override
  Country build() {
    final countries = ref.watch(countriesProvider);
    return countries[1];
  }

  set country(Country country) {
    state = country;
  }
}

@riverpod
Future<List<Country>> countryFilter(CountryFilterRef ref, String searchText) async {
  final countries = ref.watch(countriesProvider);
  if (searchText.isEmpty) {
    return countries;
  }

  await ref.debounce();
  return _filterCountries(countries, searchText);
}

List<Country> _filterCountries(List<Country> countries, String searchText) {
  final searchLower = searchText.toLowerCase().trim();
  return countries.where((country) {
    final nameLower = country.name.toLowerCase();
    final codeLower = country.isoCode.toLowerCase();
    final iddCodeLower = country.iddCode.toLowerCase();

    return nameLower.contains(searchLower) ||
        codeLower.contains(searchLower) ||
        (searchLower.startsWith('+')
            ? iddCodeLower.contains(searchLower)
            : iddCodeLower.contains('+$searchLower'));
  }).toList();
}
