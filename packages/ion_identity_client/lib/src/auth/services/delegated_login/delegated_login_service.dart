// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/data_sources/delegated_login_data_source.dart';
import 'package:ion_identity_client/src/core/identity_storage/identity_storage.dart';

class DelegatedLoginService {
  const DelegatedLoginService({
    required this.dataSource,
    required this.identityStorage,
  });

  final DelegatedLoginDataSource dataSource;
  final IdentityStorage identityStorage;

  Future<UserToken> delegatedLogin({
    required String username,
  }) async {
    final tokenResponse = await dataSource.delegatedLogin(username: username);
    await identityStorage.setToken(username: username, newToken: tokenResponse.token);

    final userToken = identityStorage.getToken(username: username);
    if (userToken == null) {
      throw const UnauthenticatedException();
    }
    return userToken;
  }
}
