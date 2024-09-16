import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/create_wallet_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_response.dart';
import 'package:ion_identity_client/src/wallets/types/list_wallets_result.dart';

class IonWalletsDataSource {
  IonWalletsDataSource({
    required this.config,
    required this.networkClient,
    required this.tokenStorage,
  });

  static const listWalletsPath = '/wallets';
  static const createWalletPath = '/wallets';

  final IonClientConfig config;
  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  TaskEither<ListWalletsFailure, ListWalletsResponse> listWallets({
    required String username,
    String? paginationToken,
  }) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(UnauthorizedListWalletsFailure());
    }

    final requestData = ListWalletsRequest(
      username: username,
      paginationToken: paginationToken,
    );

    return networkClient.get(
      listWalletsPath,
      queryParams: requestData.toJson(),
      decoder: ListWalletsResponse.fromJson,
      headers: {
        ...RequestHeaders.getAuthorizationHeader(token: token.token),
      },
    ).mapLeft(
      (l) => UnknownListWalletsFailure(),
    );
  }

  UserActionSigningRequest buildCreateWalletSigningRequest({
    required String username,
    required String network,
    required String name,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: createWalletPath,
      body: CreateWalletRequest(
        network: network,
        name: name,
      ).toJson(),
    );
  }
}
