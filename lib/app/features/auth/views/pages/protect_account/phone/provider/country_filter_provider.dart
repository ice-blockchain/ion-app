import 'package:ice/app/constants/countries.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/phone/provider/selected_country_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_filter_provider.g.dart';

@riverpod
class CountryFilter extends _$CountryFilter {
  static const _debounceDuration = Duration(milliseconds: 500);

  @override
  FutureOr<List<Country>> build(String searchText) async {
    final countries = ref.watch(countriesProvider);

    if (searchText.isEmpty) {
      return countries;
    }

    final asyncResult = await AsyncValue.guard(() async {
      await ref.debounce(_debounceDuration);
      return _filterCountries(countries, searchText);
    });

    return asyncResult.valueOrNull ?? countries;
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
}
