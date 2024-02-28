import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UsersDataNotifier extends _$UsersDataNotifier {
  @override
  Map<String, UserData> build() {
    final Map<String, UserData> userAccounts = <String, UserData>{};
    for (final UserData userAccount in mockedUserAccounts) {
      userAccounts.putIfAbsent(userAccount.id, () => userAccount);
    }

    return Map<String, UserData>.unmodifiable(userAccounts);
  }

  set userData(UserData newData) {
    final Map<String, UserData> newState = Map<String, UserData>.from(state)
      ..update(
        newData.id,
        (UserData value) => value.copyWith(
          id: newData.id,
          nickname: newData.nickname,
          name: newData.name,
          whoInvitedNickname: newData.whoInvitedNickname,
          profilePicture: newData.profilePicture,
          followers: newData.followers,
          following: newData.following,
          isVerified: newData.isVerified,
        ),
        ifAbsent: () => newData,
      );
    state = Map<String, UserData>.unmodifiable(newState);
  }
}
