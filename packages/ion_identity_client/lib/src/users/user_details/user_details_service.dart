// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/user_details/data_sources/user_details_data_source.dart';
import 'package:ion_identity_client/src/users/user_details/models/user_details.f.dart';

class UserDetailsService {
  UserDetailsService(
    this.username,
    this._dataSource,
  );

  final String username;
  final UserDetailsDataSource _dataSource;

  Future<UserDetails> details({
    required String userId,
  }) async =>
      _dataSource.fetchDetails(
        username: username,
        userId: userId,
      );
}
