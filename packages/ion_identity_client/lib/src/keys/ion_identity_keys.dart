import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/create_key/create_key_service.dart';
import 'package:ion_identity_client/src/keys/services/derive/derive_service.dart';
import 'package:ion_identity_client/src/keys/services/list_keys/list_keys_service.dart';

class IONIdentityKeys {
  IONIdentityKeys(
    this._createKeyService,
    this._deriveService,
    this._listKeysService,
  );

  final CreateKeyService _createKeyService;
  final DeriveService _deriveService;
  final ListKeysService _listKeysService;

  Future<ListKeysResponse> listKeys({
    String? owner,
    int? limit,
    String? paginationToken,
  }) =>
      _listKeysService.listKeys(
        owner: owner,
        limit: limit,
        paginationToken: paginationToken,
      );

  Future<KeyResponse> createKey({
    required String scheme,
    required String curve,
    required String name,
    required UserActionSignerNew signer,
  }) =>
      _createKeyService.createKey(
        scheme: scheme,
        curve: curve,
        name: name,
        signer: signer,
      );

  Future<DeriveResponse> derive({
    required String keyId,
    required String domain,
    required String seed,
    required UserActionSignerNew signer,
  }) =>
      _deriveService.derive(
        keyId: keyId,
        domain: domain,
        seed: seed,
        signer: signer,
      );
}
