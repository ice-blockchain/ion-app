import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/types/list_wallets_result.dart';

class IonWallets {
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
