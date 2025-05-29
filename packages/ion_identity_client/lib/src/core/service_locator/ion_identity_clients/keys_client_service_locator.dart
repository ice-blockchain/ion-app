import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/keys/ion_identity_keys.dart';
import 'package:ion_identity_client/src/keys/services/create_key/create_key_service.dart';
import 'package:ion_identity_client/src/keys/services/create_key/data_sources/create_key_data_source.dart';
import 'package:ion_identity_client/src/keys/services/derive/data_sources/derive_data_source.dart';
import 'package:ion_identity_client/src/keys/services/derive/derive_service.dart';
import 'package:ion_identity_client/src/keys/services/list_keys/data_sources/list_keys_data_source.dart';
import 'package:ion_identity_client/src/keys/services/list_keys/list_keys_service.dart';
import 'package:ion_identity_client/src/keys/services/update_key/data_sources/update_key_data_source.dart';
import 'package:ion_identity_client/src/keys/services/update_key/update_key_service.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';

class KeysClientServiceLocator {
  factory KeysClientServiceLocator() {
    return _instance;
  }

  KeysClientServiceLocator._internal();

  static final KeysClientServiceLocator _instance = KeysClientServiceLocator._internal();

  IONIdentityKeys keys({
    required String username,
    required IONIdentityConfig config,
    required IdentitySigner identitySigner,
  }) {
    return IONIdentityKeys(
      _createKeyService(
        username: username,
        config: config,
        signer: identitySigner,
      ),
      _deriveService(
        username: username,
        config: config,
        signer: identitySigner,
      ),
      _listKeysService(
        username: username,
        config: config,
      ),
      _updateKeyService(
        username: username,
        config: config,
        signer: identitySigner,
      ),
    );
  }

  CreateKeyService _createKeyService({
    required String username,
    required IONIdentityConfig config,
    required IdentitySigner signer,
  }) {
    return CreateKeyService(
      CreateKeyDataSource(username),
    );
  }

  DeriveService _deriveService({
    required String username,
    required IONIdentityConfig config,
    required IdentitySigner signer,
  }) {
    return DeriveService(
      DeriveDataSource(username),
    );
  }

  ListKeysService _listKeysService({
    required String username,
    required IONIdentityConfig config,
  }) {
    return ListKeysService(
      ListKeysDataSource(
        username,
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  UpdateKeyService _updateKeyService({
    required String username,
    required IONIdentityConfig config,
    required IdentitySigner signer,
  }) {
    return UpdateKeyService(
      UpdateKeyDataSource(username),
    );
  }
}
