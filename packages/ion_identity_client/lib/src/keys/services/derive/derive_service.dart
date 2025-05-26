import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/derive/data_sources/derive_data_source.dart';
import 'package:ion_identity_client/src/keys/services/derive/models/derive_response.c.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

class DeriveService {
  DeriveService(
    this._deriveDataSource,
    this._userActionSigner,
  );

  final DeriveDataSource _deriveDataSource;
  final UserActionSigner _userActionSigner;

  Future<DeriveResponse> derive({
    required String keyId,
    required String domain,
    required String seed,
    required OnVerifyIdentity<DeriveResponse> onVerifyIdentity,
  }) async {
    final request = _deriveDataSource.buildDeriveSigningRequest(
      keyId: keyId,
      domain: domain,
      seed: seed,
    );

    return onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return _userActionSigner.signWithPassword(
          request,
          DeriveResponse.fromJson,
          password,
        );
      },
      onPasskeyFlow: () {
        return _userActionSigner.signWithPasskey(
          request,
          DeriveResponse.fromJson,
        );
      },
      onBiometricsFlow: ({required String localisedReason, required String localisedCancel}) {
        return _userActionSigner.signWithBiometrics(
          request,
          DeriveResponse.fromJson,
          localisedReason,
          localisedCancel,
        );
      },
    );
  }
}
