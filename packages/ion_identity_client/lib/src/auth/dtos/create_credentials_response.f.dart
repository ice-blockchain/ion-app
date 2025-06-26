// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

part 'create_credentials_response.f.freezed.dart';
part 'create_credentials_response.f.g.dart';

@freezed
class CreateCredentialsResponse with _$CreateCredentialsResponse {
  factory CreateCredentialsResponse({
    required String kind,
    required String challengeIdentifier,
    required String challenge,
    required RelyingParty rp,
    required UserInformation user,
    required List<PublicKeyCredentialParameters> pubKeyCredParams,
    required String attestation,
    List<PublicKeyCredentialDescriptor>? excludeCredentials,
    AuthenticatorSelectionCriteria? authenticatorSelection,
  }) = _CreateCredentialsResponse;

  factory CreateCredentialsResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCredentialsResponseFromJson(json);
}
