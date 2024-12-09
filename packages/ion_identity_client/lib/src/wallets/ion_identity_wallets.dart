// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/create_wallet_service.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/generate_signature_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/get_wallet_assets_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/get_wallet_history_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/get_wallet_nfts_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/get_wallet_transfer_requests_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/get_wallets_service.dart';

/// A class that handles operations related to user wallets, such as listing the wallets
/// associated with a specific user.
class IONIdentityWallets {
  /// Creates an instance of [IONIdentityWallets] with the provided [username], [config],
  /// [dataSource], and [signer].
  ///
  /// - [username]: The username of the user whose wallets are being managed.
  /// - [config]: The client configuration containing necessary identifiers.
  /// - [dataSource]: The data source responsible for API interactions related to wallets.
  /// - [signer]: The passkey signer used for handling cryptographic operations, if needed.
  IONIdentityWallets({
    required this.username,
    required CreateWalletService createWalletService,
    required GetWalletsService getWalletsService,
    required GetWalletAssetsService getWalletAssetsService,
    required GetWalletNftsService getWalletNftsService,
    required GetWalletHistoryService getWalletHistoryService,
    required GetWalletTransferRequestsService getWalletTransferRequestsService,
    required GenerateSignatureService generateSignatureService,
  })  : _createWalletService = createWalletService,
        _getWalletsService = getWalletsService,
        _getWalletAssetsService = getWalletAssetsService,
        _getWalletNftsService = getWalletNftsService,
        _getWalletHistoryService = getWalletHistoryService,
        _getWalletTransferRequestsService = getWalletTransferRequestsService,
        _generateSignatureService = generateSignatureService;

  final String username;

  final CreateWalletService _createWalletService;
  final GetWalletsService _getWalletsService;
  final GetWalletAssetsService _getWalletAssetsService;
  final GetWalletNftsService _getWalletNftsService;
  final GetWalletHistoryService _getWalletHistoryService;
  final GetWalletTransferRequestsService _getWalletTransferRequestsService;
  final GenerateSignatureService _generateSignatureService;

  Future<Wallet> createWallet({
    required String network,
    required String name,
    required OnVerifyIdentity<Wallet> onVerifyIdentity,
  }) =>
      _createWalletService.createWallet(
        network: network,
        name: name,
        onVerifyIdentity: onVerifyIdentity,
      );

  /// Lists the wallets associated with the current user by making an API request.
  ///
  /// Returns a [Future] that resolves to a [List<Wallet>] containing the user's wallets.
  /// If an error occurs during the API request or processing, it will be thrown as an exception.
  Future<List<Wallet>> getWallets() => _getWalletsService.getWallets();

  Future<WalletAssets> getWalletAssets(String walletId) =>
      _getWalletAssetsService.getWalletAssets(walletId);

  Future<WalletNfts> getWalletNfts(String walletId) =>
      _getWalletNftsService.getWalletNfts(walletId);

  Future<WalletHistory> getWalletHistory(
    String walletId, {
    String? pageToken,
    int? pageSize,
  }) =>
      _getWalletHistoryService.getWalletHistory(walletId, pageToken: pageToken, pageSize: pageSize);

  Future<WalletTransferRequests> getWalletTransferRequests(
    String walletId, {
    String? pageToken,
  }) =>
      _getWalletTransferRequestsService.getWalletTransferRequests(
        walletId,
        pageToken: pageToken,
      );

  Future<GenerateSignatureResponse> generateMessageSignatureWithPasskey(
    String walletId,
    String message,
  ) =>
      _generateSignatureService.generateMessageSignatureWithPasskey(
        walletId: walletId,
        message: message,
      );

  Future<GenerateSignatureResponse> generateMessageSignatureWithPassword(
    String walletId,
    String message,
    String password,
  ) =>
      _generateSignatureService.generateMessageSignatureWithPassword(
        walletId: walletId,
        message: message,
        password: password,
      );

  Future<GenerateSignatureResponse> generateHashSignatureWithPasskey(
    String walletId,
    String hash,
  ) =>
      _generateSignatureService.generateHashSignatureWithPasskey(
        walletId: walletId,
        hash: hash,
      );

  Future<GenerateSignatureResponse> generateHashSignatureWithPassword(
    String walletId,
    String hash,
    String password,
  ) =>
      _generateSignatureService.generateHashSignatureWithPassword(
        walletId: walletId,
        hash: hash,
        password: password,
      );
}
