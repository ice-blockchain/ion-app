// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/update_user_social_profile/data_sources/update_user_social_profile_data_source.dart';
import 'package:ion_identity_client/src/users/update_user_social_profile/models/user_social_profile_data.c.dart';

class UpdateUserSocialProfileService {
  UpdateUserSocialProfileService(
    this.username,
    this._dataSource,
  );

  final String username;
  final UpdateUserSocialProfileDataSource _dataSource;

  Future<List<Map<String, dynamic>>> updateUserSocialProfile({
    required String userId,
    required UserSocialProfileData data,
  }) async =>
      _dataSource.updateUserSocialProfile(
        username: username,
        userId: userId,
        data: data,
      );
}
