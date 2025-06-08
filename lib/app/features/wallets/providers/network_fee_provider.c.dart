// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/coin_data.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_information.c.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/data/models/network_fee_type.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_fee_provider.c.g.dart';

@riverpod
Future<NetworkFeeInformation?> networkFee(
  Ref ref, {
  required NetworkData network,
  required String? walletId,
  String? assetSymbol,
}) async {
  if (walletId == null) {
    Logger.error('Cannot load fees info without walletId');
    return null;
  }

  final client = await ref.read(ionIdentityClientProvider.future);

  final estimateFees =
      await client.networks.getEstimateFees(network: network.id).onError((error, stack) {
    Logger.error('Cannot load fees info. $error', stackTrace: stack);
    return ion.EstimateFee(network: network.id);
  });

  final walletAssets =
      await client.wallets.getWalletAssets(walletId).then((result) => result.assets);

  final networkNativeToken = walletAssets.firstWhereOrNull((asset) => asset.isNative);
  final sendableAsset = _getSendableAsset(walletAssets, assetSymbol);

  if (sendableAsset == null || networkNativeToken == null) {
    Logger.error(
      'Cannot load fees info. '
      '${sendableAsset == null ? 'sendableAsset' : 'networkNativeToken'} is null.',
    );
    return null;
  }

  final nativeCoin =
      await ref.read(coinsServiceProvider.future).then((service) => service.getNativeCoin(network));

  if (nativeCoin == null) {
    Logger.error('Cannot load fees info. nativeCoin is null.');
    return NetworkFeeInformation(
      networkNativeToken: networkNativeToken,
      sendableAsset: sendableAsset,
      networkFeeOptions: [],
    );
  }

  final networkFeeOptions = _buildNetworkFeeOptions(
    estimateFees: estimateFees,
    nativeCoin: nativeCoin,
    networkNativeToken: networkNativeToken,
  );

  return NetworkFeeInformation(
    networkNativeToken: networkNativeToken,
    sendableAsset: sendableAsset,
    networkFeeOptions: networkFeeOptions,
  );
}

ion.WalletAsset? _getSendableAsset(List<ion.WalletAsset> assets, String? abbreviation) {
  if (abbreviation == null || abbreviation.isEmpty) {
    return assets.firstWhereOrNull((asset) => asset.isNative);
  }

  final result = assets.firstWhereOrNull(
    (asset) => asset.symbol.toLowerCase() == abbreviation.toLowerCase(),
  );
  // Can be native token of the testnet, if result is null
  return result ?? assets.firstWhereOrNull((asset) => asset.isNative);
}

NetworkFeeOption _buildNetworkFeeOption(
  ion.NetworkFee fee,
  NetworkFeeType type,
  CoinData nativeCoin,
  ion.WalletAsset networkNativeToken,
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

List<NetworkFeeOption> _buildNetworkFeeOptions({
  required ion.EstimateFee estimateFees,
  required CoinData nativeCoin,
  required ion.WalletAsset networkNativeToken,
}) {
  return [
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
  ];
}

/// Check if a user has enough tokens to cover a fee
bool canUserCoverFee({
  required NetworkFeeOption? selectedFee,
  required ion.WalletAsset? networkNativeToken,
}) {
  if (networkNativeToken == null) return false;

  final parsedBalance = double.tryParse(networkNativeToken.balance) ?? 0;
  final convertedBalance = parsedBalance / pow(10, networkNativeToken.decimals);

  // We don't have fees for the selected networks.
  // So if a user has native coins of the network,
  // we allow him to make a transaction.
  if (selectedFee == null) return convertedBalance > 0;

  return convertedBalance >= selectedFee.amount;
}
