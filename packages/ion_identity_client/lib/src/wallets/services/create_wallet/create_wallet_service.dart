// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/data_sources/create_wallet_data_source.dart';

class CreateWalletService {
  CreateWalletService({
    required this.username,
    required CreateWalletDataSource dataSource,
    required UserActionSigner userActionSigner,
  })  : _dataSource = dataSource,
        _userActionSigner = userActionSigner;

  final String username;
  final CreateWalletDataSource _dataSource;
  final UserActionSigner _userActionSigner;

  Future<Wallet> createWallet({
    required String network,
    required String name,
    required OnVerifyIdentity<Wallet> onVerifyIdentity,
  }) async {
    final request = _dataSource.buildCreateWalletSigningRequest(
      username: username,
      network: network,
      name: name,
    );

    return onVerifyIdentity(
      onPasswordFlow: ({required String password}) {
        return _userActionSigner.signWithPassword(
          request,
          Wallet.fromJson,
          password,
        );
      },
      onPasskeyFlow: () {
        return _userActionSigner.signWithPasskey(
          request,
          Wallet.fromJson,
        );
      },
      onBiometricsFlow: ({required String localisedReason}) {
        return _userActionSigner.signWithBiometrics(
          request,
          Wallet.fromJson,
          localisedReason,
        );
      },
    );
  }
}
