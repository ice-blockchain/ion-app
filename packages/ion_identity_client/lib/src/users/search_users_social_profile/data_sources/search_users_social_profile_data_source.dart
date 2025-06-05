// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';

class SearchUsersSocialProfileDataSource {
  SearchUsersSocialProfileDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const basePath = '/v1';

  Future<List<UserRelaysInfo>> searchForUsersByKeyword({
    required String keyword,
    required SearchUsersSocialProfileType searchType,
    required int limit,
    required int offset,
    required String username,
  }) async {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      throw const UnauthenticatedException();
    }

    final response = await _networkClient.get(
      '$basePath/user-social-profiles',
      queryParams: {
        'limit': limit,
        'keyword': keyword,
        'offset': offset,
        'type': searchType.name,
      },
      headers: RequestHeaders.getAuthorizationHeaders(
        username: username,
        token: token.token,
      ),
      decoder: (result) => (result as List<dynamic>)
          .map((e) => UserRelaysInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return response;
  }
}
