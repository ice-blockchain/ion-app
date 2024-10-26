// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/users/get_user_details/get_user_details_service.dart';

class IONUsersClient {
  IONUsersClient(this._getUserDetailsService);

  final GetUserDetailsService _getUserDetailsService;

  Future<UserDetails> getUserDetails({
    required String userId,
  }) async =>
      _getUserDetailsService.getUserDetails(userId: userId);
}
