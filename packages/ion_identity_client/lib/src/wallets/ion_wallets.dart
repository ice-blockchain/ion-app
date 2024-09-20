import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/types/create_wallet_result.dart';
import 'package:ion_identity_client/src/wallets/types/list_wallets_result.dart';

/// A class that handles operations related to user wallets, such as listing the wallets
/// associated with a specific user.
class IonWallets {
  /// Creates an instance of [IonWallets] with the provided [username], [config],
  /// [dataSource], and [signer].
  ///
  /// - [username]: The username of the user whose wallets are being managed.
  /// - [config]: The client configuration containing necessary identifiers.
  /// - [dataSource]: The data source responsible for API interactions related to wallets.
  /// - [signer]: The passkey signer used for handling cryptographic operations, if needed.
  IonWallets({
    required this.username,
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.userActionSigner,
  });

  final String username;
  final IonClientConfig config;
  final IonWalletsDataSource dataSource;
  final PasskeysSigner signer;
  final UserActionSigner userActionSigner;

  /// Lists the wallets associated with the current user by making an API request.
  ///
  /// Returns a [ListWalletsResult], which can either be a [ListWalletsSuccess]
  /// with the list of wallets on success or a specific failure type on error.
  Future<ListWalletsResult> listWallets() async {
    // TODO: add pagination
    final response = await dataSource.listWallets(username: username).run();

    return response.fold(
      (l) => l,
      (r) => ListWalletsSuccess(
        wallets: r.items,
      ),
    );
  }

  Future<CreateWalletResult> createWallet({
    required String network,
    required String name,
  }) async {
    final request = dataSource.buildCreateWalletSigningRequest(
      username: username,
      network: network,
      name: name,
    );

    final result = await userActionSigner.execute(request, Wallet.fromJson).run();

    return result.fold(
      (l) => UnknownCreateWalletFailure(l, StackTrace.current),
      (wallet) => CreateWalletSuccess(wallet: wallet),
    );
  }
}
