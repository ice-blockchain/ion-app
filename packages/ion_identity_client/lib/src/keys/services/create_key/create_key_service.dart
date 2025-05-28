import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/create_key/data_sources/create_key_data_source.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

class CreateKeyService {
  CreateKeyService(
    this._createKeyDataSource,
    this._userActionSigner,
  );

  final CreateKeyDataSource _createKeyDataSource;
  final UserActionSigner _userActionSigner;

  Future<KeyResponse> createKey({
    required String scheme,
    required String curve,
    required String name,
    required OnVerifyIdentity<KeyResponse> onVerifyIdentity,
  }) async {
    final request = _createKeyDataSource.buildCreateKeySigningRequest(
      scheme: scheme,
      curve: curve,
      name: name,
    );

    return onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return _userActionSigner.signWithPassword(
          request,
          KeyResponse.fromJson,
          password,
        );
      },
      onPasskeyFlow: () {
        return _userActionSigner.signWithPasskey(
          request,
          KeyResponse.fromJson,
        );
      },
      onBiometricsFlow: ({required String localisedReason, required String localisedCancel}) {
        return _userActionSigner.signWithBiometrics(
          request,
          KeyResponse.fromJson,
          localisedReason,
          localisedCancel,
        );
      },
    );
  }
}
