import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/features/auth/views/pages/select_country/countries.dart';

part 'select_country_return_data.freezed.dart';

@freezed
class SelectCountryReturnData with _$SelectCountryReturnData {
  const factory SelectCountryReturnData({
    required Country country,
  }) = _SelectCountryReturnData;
}
