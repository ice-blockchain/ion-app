import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network/network_failure.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_response.dart';

class IonWalletsDataSource {
  IonWalletsDataSource({
    required this.config,
    required this.networkClient,
  });

  static const listWalletsPath = '/wallets/list';

  final IonClientConfig config;
  final NetworkClient networkClient;

  TaskEither<NetworkFailure, ListWalletsResponse> listWallets({
    required String authToken,
  }) {
    final requestData = ListWalletsRequest(
      appId: config.appId,
      authToken: authToken,
    );

    return networkClient.post(
      listWalletsPath,
      data: requestData.toJson(),
      decoder: ListWalletsResponse.fromJson,
    );
  }
}
