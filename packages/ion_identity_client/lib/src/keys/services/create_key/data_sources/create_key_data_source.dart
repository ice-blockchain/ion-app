import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/keys/services/create_key/models/create_key_request.c.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class CreateKeyDataSource {
  const CreateKeyDataSource(this.username);

  final String username;

  static const createKeyPath = '/keys';

  UserActionSigningRequest buildCreateKeySigningRequest({
    required String scheme,
    required String curve,
    required String name,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: createKeyPath,
      body: CreateKeyRequest(
        scheme: scheme,
        curve: curve,
        name: name,
      ).toJson(),
    );
  }
}
