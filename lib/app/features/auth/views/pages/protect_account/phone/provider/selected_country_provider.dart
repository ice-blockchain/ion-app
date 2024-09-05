import 'package:ice/app/constants/countries.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_country_provider.g.dart';

@riverpod
List<Country> countries(CountriesRef ref) => countriesData;

@riverpod
class SelectedCountry extends _$SelectedCountry {
  @override
  Country build() {
    final countries = ref.watch(countriesProvider);
    return countries[1];
  }

  void setCountry(Country country) {
    state = country;
  }
}
