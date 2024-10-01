// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion_data.dart';

class Fido2Assertion {
  Fido2Assertion(
    this.kind,
    this.credentialAssertion,
  );

  factory Fido2Assertion.fromJson(JsonObject json) {
    return Fido2Assertion(
      json['kind'] as String,
      Fido2AssertionData.fromJson(json['credentialAssertion'] as JsonObject),
    );
  }

  final String kind;
  final Fido2AssertionData credentialAssertion;

  JsonObject toJson() => {
        'kind': kind,
        'credentialAssertion': credentialAssertion.toJson(),
      };

  @override
  String toString() => 'Fido2Assertion(kind: $kind, credentialAssertion: $credentialAssertion)';
}
