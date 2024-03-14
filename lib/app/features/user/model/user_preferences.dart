import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';

@Freezed(copyWith: true)
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required bool isBalanceVisible,
    required bool isWalletValuesVisible,
  }) = _UserPreferences;
}
