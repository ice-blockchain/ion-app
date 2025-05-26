import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/create_key/create_key_service.dart';
import 'package:ion_identity_client/src/keys/services/create_key/models/create_key_response.c.dart';
import 'package:ion_identity_client/src/keys/services/derive/derive_service.dart';
import 'package:ion_identity_client/src/keys/services/derive/models/derive_response.c.dart';

class IONIdentityKeys {
  IONIdentityKeys(
    this._createKeyService,
    this._deriveService,
  );

  final CreateKeyService _createKeyService;
  final DeriveService _deriveService;

  Future<CreateKeyResponse> createKey({
    required String scheme,
    required String curve,
    required String name,
    required OnVerifyIdentity<CreateKeyResponse> onVerifyIdentity,
  }) =>
      _createKeyService.createKey(
        scheme: scheme,
        curve: curve,
        name: name,
        onVerifyIdentity: onVerifyIdentity,
      );

  Future<DeriveResponse> derive({
    required String keyId,
    required String domain,
    required String seed,
    required OnVerifyIdentity<DeriveResponse> onVerifyIdentity,
  }) =>
      _deriveService.derive(
        keyId: keyId,
        domain: domain,
        seed: seed,
        onVerifyIdentity: onVerifyIdentity,
      );
}
