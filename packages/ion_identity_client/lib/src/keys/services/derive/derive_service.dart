import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/derive/data_sources/derive_data_source.dart';

class DeriveService {
  DeriveService(
    this._deriveDataSource,
  );

  final DeriveDataSource _deriveDataSource;

  // New simplified method using UserActionSignerNew
  Future<DeriveResponse> derive({
    required String keyId,
    required String domain,
    required String seed,
    required UserActionSignerNew signer,
  }) async {
    final request = _deriveDataSource.buildDeriveSigningRequest(
      keyId: keyId,
      domain: domain,
      seed: seed,
    );

    return signer.sign<DeriveResponse>(request, DeriveResponse.fromJson);
  }
}
