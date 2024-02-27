import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  UserData build() {
    return mockedUserAccounts[0];
  }

  set userData(UserData newData) {
    state = state.copyWith(
      id: newData.id,
      nickname: newData.nickname,
      name: newData.name,
      whoInvitedNickname: newData.whoInvitedNickname,
      profilePicture: newData.profilePicture,
      followers: newData.followers,
      following: newData.following,
      isVerified: newData.isVerified,
    );
  }
}
