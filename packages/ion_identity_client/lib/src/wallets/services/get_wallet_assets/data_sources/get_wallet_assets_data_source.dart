import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/dtos/wallet_assets_dto.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/result_types/get_wallet_assets_result.dart';
import 'package:sprintf/sprintf.dart';

class GetWalletAssetsDataSource {
  const GetWalletAssetsDataSource(
    this._networkClient,
    this._tokenStorage,
  );

  final NetworkClient _networkClient;
  final TokenStorage _tokenStorage;

  static const walletAssetsPath = '/wallets/%s/assets';

  TaskEither<GetWalletAssetsFailure, WalletAssetsDto> getWalletAssets(
    String username,
    String walletId,
  ) {
    final token = _tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(
        GetWalletAssetsFailure(
          RequestExecutionNetworkFailure(401, StackTrace.current),
        ),
      );
    }

    return _networkClient
        .get(
          sprintf(walletAssetsPath, [walletId]),
          headers: RequestHeaders.getAuthorizationHeader(token: token.token),
          decoder: WalletAssetsDto.fromJson,
        )
        .mapLeft(GetWalletAssetsFailure.new);
  }
}
