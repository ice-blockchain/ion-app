// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/logout/data_sources/logout_data_source.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';

class LogoutService {
  const LogoutService({
    required this.username,
    required this.dataSource,
    required this.tokenStorage,
  });

  final String username;
  final LogoutDataSource dataSource;
  final TokenStorage tokenStorage;

  Future<void> logOut() async {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }
    await dataSource.logOut(username: username, token: token.token);
    return tokenStorage.removeToken(username: username);
  }
}
