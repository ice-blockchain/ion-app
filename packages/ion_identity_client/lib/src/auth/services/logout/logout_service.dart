// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/logout/data_sources/logout_data_source.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';

class LogoutService {
  const LogoutService({
    required this.username,
    required this.dataSource,
    required this.identityStorage,
  });

  final String username;
  final LogoutDataSource dataSource;
  final IdentityStorage identityStorage;

  Future<void> logOut() async {
    final token = identityStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }
    await dataSource.logOut(username: username, token: token.token);
    return identityStorage.clearAllUserData(username: username);
  }
}
