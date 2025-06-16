// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/utils.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/users/update_user_social_profile/models/update_user_social_profile_response.c.dart';

class UpdateUserSocialProfileDataSource {
  UpdateUserSocialProfileDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const basePath = '/v1/users';

  Future<List<Map<String, dynamic>>> updateUserSocialProfile({
    required String username,
    required String userId,
    required UserSocialProfileData data,
  }) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    try {
      final response = await _networkClient.patch(
        '$basePath/$userId/profiles/social',
        data: data.toJson(),
        headers: RequestHeaders.getAuthorizationHeaders(
          username: username,
          token: token.token,
        ),
        decoder: (result) =>
            parseJsonObject(result, fromJson: UpdateUserSocialProfileResponse.fromJson),
      );
      return response.usernameProof ?? [];
    } on RequestExecutionException catch (e) {
      final exception = _mapException(e);
      throw exception;
    }
  }

  Exception _mapException(RequestExecutionException e) {
    if (e.error is! DioException) return e;

    final exception = e.error as DioException;
    if (InvalidNicknameException.isMatch(exception)) {
      return InvalidNicknameException();
    }
    if (NicknameAlreadyExistsException.isMatch(exception)) {
      return NicknameAlreadyExistsException();
    }

    return e;
  }
}
