// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/get_wallet_assets_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/get_wallet_nfts_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/get_wallets_service.dart';
import 'package:ion_identity_client/src/wallets/types/create_wallet_result.dart';

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
    required IonWalletsDataSource dataSource,
    required UserActionSigner userActionSigner,
    required GetWalletsService getWalletsService,
    required GetWalletAssetsService getWalletAssetsService,
    required GetWalletNftsService getWalletNftsService,
  })  : _dataSource = dataSource,
        _userActionSigner = userActionSigner,
        _getWalletsService = getWalletsService,
        _getWalletAssetsService = getWalletAssetsService,
        _getWalletNftsService = getWalletNftsService;

  final String username;
  final IonWalletsDataSource _dataSource;
  final UserActionSigner _userActionSigner;

  final GetWalletsService _getWalletsService;
  final GetWalletAssetsService _getWalletAssetsService;
  final GetWalletNftsService _getWalletNftsService;
  Future<CreateWalletResult> createWallet({
    required String network,
    required String name,
  }) async {
    final request = _dataSource.buildCreateWalletSigningRequest(
      username: username,
      network: network,
      name: name,
    );

    final result = await _userActionSigner.execute(request, Wallet.fromJson).run();

    return result.fold(
      (l) => UnknownCreateWalletFailure(l, StackTrace.current),
      (wallet) => CreateWalletSuccess(wallet: wallet),
    );
  }

  /// Lists the wallets associated with the current user by making an API request.
  ///
  /// Returns a [Future] that resolves to a [List<Wallet>] containing the user's wallets.
  /// If an error occurs during the API request or processing, it will be thrown as an exception.
  Future<List<Wallet>> getWallets() => _getWalletsService.getWallets();

  Future<WalletAssets> getWalletAssets(String walletId) =>
      _getWalletAssetsService.getWalletAssets(walletId);

  Future<WalletNfts> getWalletNfts(String walletId) =>
      _getWalletNftsService.getWalletNfts(walletId);
}
