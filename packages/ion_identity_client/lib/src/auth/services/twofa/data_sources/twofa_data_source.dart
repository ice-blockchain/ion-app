// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/twofa/models/init_twofa_request.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:sprintf/sprintf.dart';

class TwoFADataSource {
  const TwoFADataSource({
    required this.networkClient,
    required this.tokenStorage,
  });

  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  static const twoFaPath = '/v1/users/%s/2fa/%s/verification-requests';

  Future<Map<String, dynamic>> requestTwoFACode({
    required String username,
    required String userId,
    required String twoFAOption,
    required Map<String, String>? verificationCodes,
    required String signature,
    String? email,
    String? phoneNumber,
  }) async {
    final token = tokenStorage.getToken(username: username)?.token;
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final body = InitTwoFARequest(
      verificationCodes: verificationCodes,
      email: email,
      phoneNumber: phoneNumber,
    );

    return networkClient.put(
      sprintf(twoFaPath, [userId, twoFAOption]),
      data: body.toJson(),
      headers: {
        ...RequestHeaders.getAuthorizationHeaders(token: token, username: username),
        RequestHeaders.ionIdentityUserAction: signature,
      },
      decoder: (response) => response,
    );
  }

  Future<Map<String, dynamic>> verifyTwoFA({
    required String username,
    required String userId,
    required String twoFAOption,
    required String code,
  }) async {
    final token = tokenStorage.getToken(username: username)?.token;
    if (token == null) {
      throw const UnauthenticatedException();
    }

    return networkClient.patch(
      sprintf(twoFaPath, [userId, twoFAOption]),
      queryParams: {'code': code},
      headers: RequestHeaders.getAuthorizationHeaders(token: token, username: username),
      decoder: (response) => response,
    );
  }
}
