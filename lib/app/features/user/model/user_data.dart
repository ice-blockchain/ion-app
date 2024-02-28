import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';

@Freezed(copyWith: true)
class UserData with _$UserData {
  const factory UserData({
    required String id,
    required String nickname,
    required String name,
    required String whoInvitedNickname,
    required String profilePicture,
    int? following,
    int? followers,
    bool? isVerified,
  }) = _UserData;
}
