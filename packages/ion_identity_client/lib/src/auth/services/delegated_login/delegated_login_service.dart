// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/data_sources/delegated_login_data_source.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';

class DelegatedLoginService {
  const DelegatedLoginService({
    required this.username,
    required this.dataSource,
    required this.tokenStorage,
  });

  final String username;
  final DelegatedLoginDataSource dataSource;
  final TokenStorage tokenStorage;

  Future<UserToken> delegatedLogin() async {
    final token = await dataSource.delegatedLogin(username: username);
    await tokenStorage.setToken(username: username, newToken: token);
    return UserToken(username: username, token: token);
  }
}
