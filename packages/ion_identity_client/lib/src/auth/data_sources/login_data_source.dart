// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/result_types/login_user_result.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_complete_request.dart';

class LoginDataSource {
  LoginDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const loginInitPath = '/auth/login/init';
  static const loginCompletePath = '/auth/login';

  TaskEither<LoginUserFailure, UserActionChallenge> loginInit({
    required String username,
  }) {
    final requestData = LoginInitRequest(username: username);

    return networkClient
        .post(
          loginInitPath,
          data: requestData.toJson(),
          decoder: UserActionChallenge.fromJson,
        )
        .mapLeft(
          (l) => switch (l) {
            RequestExecutionNetworkFailure(:final error) =>
              _handleRequestExecutionNetworkFailure(error),
            _ => UnknownLoginUserFailure(l),
          },
        );
  }

  TaskEither<LoginUserFailure, Authentication> loginComplete({
    required Fido2Assertion assertion,
    required String challengeIdentifier,
  }) {
    final requestData = UserActionSigningCompleteRequest(
      challengeIdentifier: challengeIdentifier,
      firstFactor: assertion,
    );

    return networkClient
        .post(
          loginCompletePath,
          data: requestData.toJson(),
          decoder: Authentication.fromJson,
        )
        .mapLeft(
          (l) => switch (l) {
            RequestExecutionNetworkFailure(:final error) =>
              _handleRequestExecutionNetworkFailure(error),
            _ => UnknownLoginUserFailure(l),
          },
        );
  }

  LoginUserFailure _handleRequestExecutionNetworkFailure(Object error) {
    switch (error) {
      case DioException(:final response) when response?.statusCode == 400:
        return const AccountDeactivatedLoginUserFailure();
      case DioException(:final response) when response?.statusCode == 401:
        return const NoCredentialsLoginUserFailure();
      case DioException(:final response) when response?.statusCode == 403:
        return const InvalidCodeLoginUserFailure();
      default:
        return const UnknownLoginUserFailure();
    }
  }
}
