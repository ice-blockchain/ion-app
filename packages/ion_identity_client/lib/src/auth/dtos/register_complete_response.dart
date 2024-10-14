// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/authentication.dart';
import 'package:ion_identity_client/src/auth/dtos/credential.dart';
import 'package:ion_identity_client/src/auth/dtos/user.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

class RegistrationCompleteResponse {
  RegistrationCompleteResponse({
    required this.credential,
    required this.user,
    required this.authentication,
  });

  factory RegistrationCompleteResponse.fromJson(JsonObject json) {
    return RegistrationCompleteResponse(
      credential: Credential.fromJson(json['credential'] as JsonObject),
      user: User.fromJson(json['user'] as JsonObject),
      authentication: Authentication.fromJson(json['authentication'] as JsonObject),
    );
  }

  final Credential credential;
  final User user;
  final Authentication authentication;

  @override
  String toString() {
    return 'RegistrationCompleteResponse(credential: $credential, user: $user, authentication: $authentication)';
  }
}
