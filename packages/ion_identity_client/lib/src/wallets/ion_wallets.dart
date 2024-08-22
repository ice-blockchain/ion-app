import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/types/list_wallets_result.dart';

/// A class that handles operations related to user wallets, such as listing the wallets
/// associated with a specific user.
class IonWallets {
  /// Creates an instance of [IonWallets] with the provided [username], [config],
  /// [dataSource], [signer], and [tokenStorage].
  ///
  /// - [username]: The username of the user whose wallets are being managed.
  /// - [config]: The client configuration containing necessary identifiers.
  /// - [dataSource]: The data source responsible for API interactions related to wallets.
  /// - [signer]: The passkey signer used for handling cryptographic operations, if needed.
  /// - [tokenStorage]: The token storage used to securely manage authentication tokens.
  IonWallets({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
  });

  final String username;
  final IonClientConfig config;
  final IonWalletsDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;

  /// Lists the wallets associated with the current user by making an API request.
  ///
  /// This method retrieves the authentication token from the [TokenStorage] and
  /// uses it to request the list of wallets from the [dataSource].
  ///
  /// Returns a [ListWalletsResult], which can either be a [ListWalletsSuccess]
  /// with the list of wallets on success or a specific failure type on error.
  Future<ListWalletsResult> listWallets() async {
    final response = await dataSource
        .listWallets(authToken: tokenStorage.getToken(username: username)?.token ?? '')
        .run();

    return response.fold(
      (l) => l,
      (r) => ListWalletsSuccess(
        wallets: r.items,
      ),
    );
  }
}
