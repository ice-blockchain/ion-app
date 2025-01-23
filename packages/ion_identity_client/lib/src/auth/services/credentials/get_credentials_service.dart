// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/credentials/data_sources/get_credentials_data_source.dart';

class GetCredentialsService {
  GetCredentialsService({
    required this.username,
    required this.dataSource,
  });

  final String username;
  final GetCredentialsDataSource dataSource;

  Future<List<Credential>> getCredentialsList() =>
      dataSource.getCredentialsList(username: username);
}
