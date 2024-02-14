import 'package:ice/app/features/core/model/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  UserData build() {
    return const UserData(
      nickname: 'sammyathowards',
      name: 'Samantha Howard',
      whoInvitedNickname: 'landmark',
      profilePicture:
          'https://ice.io/wp-content/uploads/2022/12/Invite-your-friends-and-create-your-micro-community.jpg',
      following: 280,
      followers: 406,
    );
  }

  set userData(UserData newData) {
    state = state.copyWith(
      nickname: newData.nickname,
      name: newData.name,
      whoInvitedNickname: newData.whoInvitedNickname,
      profilePicture: newData.profilePicture,
      followers: newData.followers,
      following: newData.following,
    );
  }
}
