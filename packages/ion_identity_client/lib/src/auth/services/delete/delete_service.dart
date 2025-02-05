// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/delete/data_sources/delete_user_data_source.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/core/storage/biometrics_state_storage.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';

class DeleteService {
  const DeleteService({
    required this.username,
    required this.dataSource,
    required this.tokenStorage,
    required this.privateKeyStorage,
    required this.biometricsStateStorage,
    required this.extractUserIdService,
  });

  final String username;
  final DeleteUserDataSource dataSource;
  final TokenStorage tokenStorage;
  final PrivateKeyStorage privateKeyStorage;
  final BiometricsStateStorage biometricsStateStorage;
  final ExtractUserIdService extractUserIdService;

  Future<void> deleteUser({required String base64Kind5Event}) async {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }
    final userId = extractUserIdService.extractUserId(username: username);
    await dataSource.deleteUser(
      username: username,
      token: token.token,
      userId: userId,
      base64Kind5Event: base64Kind5Event,
    );
    await Future.wait([
      tokenStorage.removeToken(username: username),
      privateKeyStorage.removePrivateKey(username: username),
      biometricsStateStorage.removeBiometricsState(username: username),
    ]);
  }
}
