// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/get_user_details/data_sources/get_user_details_data_source.dart';
import 'package:ion_identity_client/src/users/get_user_details/models/user_details.dart';

class GetUserDetailsService {
  GetUserDetailsService(
    this.username,
    this._dataSource,
  );

  final String username;
  final GetUserDetailsDataSource _dataSource;

  Future<UserDetails> getUserDetails({
    required String userId,
  }) async =>
      _dataSource.getUserDetails(
        username: username,
        userId: userId,
      );
}
