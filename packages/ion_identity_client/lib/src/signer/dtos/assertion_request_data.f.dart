// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/credential_assertion_data.f.dart';

part 'assertion_request_data.f.freezed.dart';
part 'assertion_request_data.f.g.dart';

@freezed
class AssertionRequestData with _$AssertionRequestData {
  const factory AssertionRequestData({
    required CredentialKind kind,
    required CredentialAssertionData credentialAssertion,
  }) = _AssertionRequestData;

  factory AssertionRequestData.fromJson(JsonObject json) => _$AssertionRequestDataFromJson(json);
}
