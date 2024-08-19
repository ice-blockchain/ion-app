import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/public_key_credential_descriptor.dart';

class AllowCredentials {
  AllowCredentials(
    this.webauthn,
    this.key,
  );

  factory AllowCredentials.fromJson(JsonObject json) {
    return AllowCredentials(
      List<PublicKeyCredentialDescriptor>.from(
        json['webauthn'].map(PublicKeyCredentialDescriptor.fromJson) as List<dynamic>,
      ),
      List<PublicKeyCredentialDescriptor>.from(
        json['key'].map(PublicKeyCredentialDescriptor.fromJson) as List<dynamic>,
      ),
    );
  }

  final List<PublicKeyCredentialDescriptor> webauthn;
  final List<PublicKeyCredentialDescriptor> key;

  @override
  String toString() => 'AllowCredentials(webauthn: $webauthn, key: $key)';
}
