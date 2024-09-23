import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

@Freezed(copyWith: true)
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String name,
    required String about,
    required String picture,
    String? displayName,
    String? website,
    String? banner,
    @Default(false) bool bot,
  }) = _UserData;
}
