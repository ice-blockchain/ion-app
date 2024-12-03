// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class RegisterDataSource {
  const RegisterDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const registerInitPath = '/auth/registration/delegated';
  static const registerCompletePath = '/auth/registration/enduser';

  Future<UserRegistrationChallenge> registerInit({
    required String username,
  }) async {
    return networkClient.post(
      registerInitPath,
      data: RegisterInitRequest(email: username).toJson(),
      decoder: UserRegistrationChallenge.fromJson,
    );
  }

  Future<RegistrationCompleteResponse> registerComplete({
    required CredentialRequestData credentialData,
    required String temporaryAuthenticationToken,
  }) {
    return networkClient.post(
      registerCompletePath,
      data: SignedChallenge(firstFactorCredential: credentialData).toJson(),
      decoder: RegistrationCompleteResponse.fromJson,
      headers: RequestHeaders.getTokenHeader(token: temporaryAuthenticationToken),
    );
  }
}
