// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class RecoverUserDataSource {
  RecoverUserDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const createDelegatedRecoveryChallengePath = '/auth/recover/user/delegated';
  static const recoverUserPath = '/auth/recover/user';

  Future<UserRegistrationChallenge> createDelegatedRecoveryChallenge({
    required String username,
    required String credentialId,
    List<TwoFAType>? twoFATypes,
  }) async {
    try {
      return await networkClient.post(
        createDelegatedRecoveryChallengePath,
        data: {
          'username': username,
          'credentialId': credentialId,
          '2FAVerificationCodes': {
            for (final twoFAType in twoFATypes ?? []) twoFAType.option: twoFAType.value,
          },
        },
        decoder: UserRegistrationChallenge.fromJson,
      );
    } on RequestExecutionException catch (e) {
      final dioException = e.error is DioException ? e.error as DioException : null;

      if (dioException?.response?.statusCode == 403 &&
          dioException?.response?.data['error']['message'] == '2FA_REQUIRED') {
        throw const TwoFARequiredException();
      }
      rethrow;
    }
  }

  Future<JsonObject> recoverUser({
    required JsonObject recoveryData,
    required String temporaryAuthenticationToken,
  }) {
    return networkClient.post(
      recoverUserPath,
      data: recoveryData,
      headers: RequestHeaders.getTokenHeader(token: temporaryAuthenticationToken),
      decoder: (json) => json,
    );
  }
}
