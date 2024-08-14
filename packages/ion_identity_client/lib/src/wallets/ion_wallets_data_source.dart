import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/utils/ion_service_locator.dart';
import 'package:ion_identity_client/src/utils/types.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/list_wallets_response.dart';

class IonWalletsDataSource {
  IonWalletsDataSource._({
    required this.config,
    required this.dio,
  });

  factory IonWalletsDataSource.createDefault({
    required IonClientConfig config,
  }) {
    final dio = IonServiceLocator.getDio(config: config);

    return IonWalletsDataSource._(
      config: config,
      dio: dio,
    );
  }

  static const listWalletsPath = '/wallets/list';

  final IonClientConfig config;
  final Dio dio;

  Future<ListWalletsResponse> listWallets({
    required String authToken,
  }) async {
    final requestData = ListWalletsRequest(
      appId: config.appId,
      authToken: authToken,
    );

    final response = await dio.post<JsonObject>(
      listWalletsPath,
      data: requestData.toJson(),
    );

    return ListWalletsResponse.fromJson(response.data ?? {});
  }
}
