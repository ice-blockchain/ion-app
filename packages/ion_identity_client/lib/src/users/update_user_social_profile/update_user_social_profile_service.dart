// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/update_user_social_profile/data_sources/update_user_social_profile_data_source.dart';
import 'package:ion_identity_client/src/users/update_user_social_profile/models/update_user_social_profile_response.f.dart';
import 'package:ion_identity_client/src/users/update_user_social_profile/models/user_social_profile_data.f.dart';

class UpdateUserSocialProfileService {
  UpdateUserSocialProfileService(
    this.username,
    this._dataSource,
  );

  final String username;
  final UpdateUserSocialProfileDataSource _dataSource;

  Future<UpdateUserSocialProfileResponse> updateUserSocialProfile({
    required String userId,
    required UserSocialProfileData data,
  }) async =>
      _dataSource.updateUserSocialProfile(
        username: username,
        userId: userId,
        data: data,
      );
}
