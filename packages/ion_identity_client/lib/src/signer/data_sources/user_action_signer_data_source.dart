import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_challenge.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_complete_request.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_signing_init_request.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signer_result.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class UserActionSignerDataSource {
  const UserActionSignerDataSource({
    required this.networkClient,
    required this.tokenStorage,
  });

  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  static const initPath = '/auth/action/init';
  static const completePath = '/auth/action';

  TaskEither<UserActionSignerFailure, UserActionChallenge> createUserActionSigningChallenge(
    String username,
    UserActionSigningInitRequest request,
  ) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(
        UserActionSignerInitRequestFailure(
          'Unauthorized',
          StackTrace.current,
        ),
      );
    }

    return networkClient
        .post(
          initPath,
          data: request.toJson(),
          headers: {
            ...RequestHeaders.getAuthorizationHeader(token: token.token),
          },
          decoder: UserActionChallenge.fromJson,
        )
        .mapLeft(
          (l) => const UserActionSignerInitRequestFailure(),
        );
  }

  TaskEither<UserActionSignerFailure, String> createUserActionSignature(
    String username,
    Fido2Assertion assertion,
    String challengeIdentifier,
  ) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(
        UserActionSignerSignatureRequestFailure(
          'Unauthorized',
          StackTrace.current,
        ),
      );
    }

    final requestData = UserActionSigningCompleteRequest(
      challengeIdentifier: challengeIdentifier,
      firstFactor: assertion,
    );

    return networkClient
        .post(
          completePath,
          data: requestData.toJson(),
          headers: {
            ...RequestHeaders.getAuthorizationHeader(token: token.token),
          },
          decoder: (response) => response['userAction'] as String,
        )
        .mapLeft(
          (l) => const UserActionSignerSignatureRequestFailure(),
        );
  }

  TaskEither<UserActionSignerFailure, T> makeRequest<T>(
    String username,
    String signature,
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  ) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(
        UserActionSignerCompleteRequestFailure(
          'Unauthorized',
          StackTrace.current,
        ),
      );
    }

    final headers = {
      ...RequestHeaders.getAuthorizationHeader(token: token.token),
      RequestHeaders.ionIdentityUserAction: signature,
    };

    return switch (request.method) {
      HttpMethod.post => networkClient.post(
          request.path,
          data: request.body,
          headers: headers,
          decoder: responseDecoder,
        ),
      _ => throw UnimplementedError('Method ${request.method} is not supported'),
    }
        .mapLeft(
      (l) => UserActionSignerCompleteRequestFailure(l, StackTrace.current),
    );
  }
}
