// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/network_fee_information.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_fee_provider.c.g.dart';

@riverpod
Future<NetworkFeeInformation?> networkFee(
  Ref ref, {
  required Network network,
  required String? walletId,
  required String assetSymbol,
}) async {
  if (walletId == null) {
    Logger.error('Cannot load fees info without walletId');
    return null;
  }

  final client = await ref.read(ionIdentityClientProvider.future);

  final estimateFees = await client.networks.getEstimateFees(network: network.serverName);
  final walletAssets =
      await client.wallets.getWalletAssets(walletId).then((result) => result.assets);

  final networkNativeToken = walletAssets.firstWhereOrNull((asset) => asset.isNative);
  final sendableAsset = _getSendableAsset(walletAssets, assetSymbol);

  if (sendableAsset == null || networkNativeToken == null) {
    // No sendable asset found or native token of the network
    Logger.error(
      'Cannot load fees info. '
      '${sendableAsset == null ? 'sendableAsset' : 'networkNativeToken'} is null.',
    );
    return null;
  }

  final nativeCoin = await _getNativeCoin(
    coinsService: await ref.read(coinsServiceProvider.future),
    asset: networkNativeToken,
    network: network,
  );

  if (nativeCoin == null) {
    // No info about the native coin of the network
    Logger.error('Cannot load fees info. nativeCoin is null.');
    return null;
  }

  return NetworkFeeInformation(
    networkNativeToken: networkNativeToken,
    sendableAsset: sendableAsset,
    networkFeeOptions: [
      if (estimateFees.slow != null)
        _buildNetworkFeeOption(
          estimateFees.slow!,
          NetworkFeeType.slow,
          nativeCoin,
          networkNativeToken,
        ),
      if (estimateFees.standard != null)
        _buildNetworkFeeOption(
          estimateFees.standard!,
          NetworkFeeType.standard,
          nativeCoin,
          networkNativeToken,
        ),
      if (estimateFees.fast != null)
        _buildNetworkFeeOption(
          estimateFees.fast!,
          NetworkFeeType.fast,
          nativeCoin,
          networkNativeToken,
        ),
    ],
  );
}

Future<CoinData?> _getNativeCoin({
  required CoinsService coinsService,
  required WalletAsset asset,
  required Network network,
}) async {
  final nativeCoin = await coinsService
      .getCoinsByFilters(symbol: asset.symbol, network: network)
      .then((coins) => coins.firstOrNull);

  if (nativeCoin != null) return nativeCoin;

  // If search of a native token using the symbol and network failed,
  // try using an empty contract address. It's usually for native to the network.
  return coinsService
      .getCoinsByFilters(network: network, contractAddress: '')
      .then((coins) => coins.firstOrNull);
}

WalletAsset? _getSendableAsset(List<WalletAsset> assets, String abbreviation) {
  final result = assets.firstWhereOrNull(
    (asset) => asset.symbol.toLowerCase() == abbreviation.toLowerCase(),
  );
  // Can be native token of the testnet, if result is null
  return result ?? assets.firstWhereOrNull((asset) => asset.isNative);
}

NetworkFeeOption _buildNetworkFeeOption(
  NetworkFee fee,
  NetworkFeeType type,
  CoinData nativeCoin,
  WalletAsset networkNativeToken,
) {
  double calculateAmount(String maxFeePerGas) =>
      double.parse(maxFeePerGas) / pow(10, networkNativeToken.decimals);
  double calculatePriceUSD(double amount) => amount * nativeCoin.priceUSD;

  final amount = calculateAmount(fee.maxFeePerGas);
  return NetworkFeeOption(
    amount: amount,
    priceUSD: calculatePriceUSD(amount),
    symbol: networkNativeToken.symbol,
    arrivalTime: fee.waitTime,
    type: type,
  );
}

// Future<void> _loadFeesInfo() async {
//     final client = await ref.read(ionIdentityClientProvider.future);

//     if (state.assetData case final CoinAssetData coin) {
//       final walletId = coin.selectedOption?.walletId;

//       if (walletId == null) {
//         Logger.error('Cannot load fees info. walletId is null.');
//         // No info about the wallet from which the coin should be sent
//         return;
//       }

//       final estimateFees = await client.networks.getEstimateFees(network: state.network.serverName);
//       final walletAssets =
//           await client.wallets.getWalletAssets(walletId).then((result) => result.assets);

//       final networkNativeToken = walletAssets.firstWhereOrNull((asset) => asset.isNative);
//       final sendableAsset = _getSendableAsset(walletAssets, coin.coinsGroup.abbreviation);

//       if (sendableAsset == null || networkNativeToken == null) {
//         // No sendable asset found or native token of the network
//         Logger.error(
//           'Cannot load fees info. '
//           '${sendableAsset == null ? 'sendableAsset' : 'networkNativeToken'} is null.',
//         );
//         return;
//       }

//       final nativeCoin = await _getNativeCoin(networkNativeToken);

//       if (nativeCoin == null) {
//         // No info about the native coin of the network
//         Logger.error('Cannot load fees info. nativeCoin is null.');
//         return;
//       }

//       final options = [
//         if (estimateFees.slow != null)
//           _buildNetworkFeeOption(
//             estimateFees.slow!,
//             NetworkFeeType.slow,
//             nativeCoin,
//             networkNativeToken,
//           ),
//         if (estimateFees.standard != null)
//           _buildNetworkFeeOption(
//             estimateFees.standard!,
//             NetworkFeeType.standard,
//             nativeCoin,
//             networkNativeToken,
//           ),
//         if (estimateFees.fast != null)
//           _buildNetworkFeeOption(
//             estimateFees.fast!,
//             NetworkFeeType.fast,
//             nativeCoin,
//             networkNativeToken,
//           ),
//       ];

//       state = state.copyWith(
//         networkFeeOptions: options,
//         selectedNetworkFeeOption: options.firstOrNull,
//         networkNativeToken: networkNativeToken.copyWith(
//           name: networkNativeToken.name ?? nativeCoin.name,
//         ),
//         assetData: coin.copyWith(
//           associatedAssetWithSelectedOption: sendableAsset,
//         ),
//       );

//     }
