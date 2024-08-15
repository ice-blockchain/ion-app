import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/utils/ion_service_locator.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';

class IonWallets {
  IonWallets._({
    required this.config,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
  });

  factory IonWallets.createDefault({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return IonWallets._(
      config: config,
      signer: signer,
      dataSource: IonWalletsDataSource.createDefault(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  final IonClientConfig config;
  final IonWalletsDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;

  Future<void> listWallets() async {
    await dataSource.listWallets(authToken: tokenStorage.getToken() ?? 'token').run();
  }
}
