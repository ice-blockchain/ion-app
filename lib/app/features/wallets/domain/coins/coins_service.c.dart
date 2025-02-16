// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/wallets/data/coins/repository/coins_repository.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/model/network_fee_type.dart';
import 'package:ion/app/features/wallets/model/send_coins_result.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_service.c.g.dart';
part 'transfer_factory.dart';

@riverpod
Future<CoinsService> coinsService(Ref ref) async {
  return CoinsService(
    ref.watch(coinsRepositoryProvider),
    await ref.watch(ionIdentityClientProvider.future),
  );
}

class CoinsService {
  CoinsService(this._coinsRepository, this._ionIdentityClient);

  final CoinsRepository _coinsRepository;
  final IONIdentityClient _ionIdentityClient;

  Stream<Iterable<CoinData>> watchCoins(Iterable<String>? coinIds) {
    return _coinsRepository.watchCoins(coinIds).map((coins) => coins.map(CoinData.fromDB));
  }

  Future<Iterable<CoinData>> getCoinsByFilters({
    String? symbolGroup,
    String? symbol,
    Network? network,
    String? contractAddress,
  }) async {
    return _coinsRepository
        .getCoinsByFilters(
          symbolGroup: symbolGroup,
          symbol: symbol,
          network: network?.id,
          contractAddress: contractAddress,
        )
        .then((result) => result.map(CoinData.fromDB));
  }

  Future<Iterable<CoinData>> getSyncedCoinsBySymbolGroup(String symbolGroup) {
    return _ionIdentityClient.coins.getCoinsBySymbolGroup(symbolGroup).then(
      (coins) {
        return coins
            .where((e) => Network.allowedNetworkIds.contains(e.network.toLowerCase()))
            .map(CoinData.fromDTO);
      },
    );
  }

  Future<SendCoinsResult> send({
    required double amount,
    required Wallet senderWallet,
    required String receiverAddress,
    required WalletAsset sendableAsset,
    required OnVerifyIdentity<Map<String, dynamic>> onVerifyIdentity,
  }) async {
    final transfer = _TransferFactory().create(
      receiverAddress: receiverAddress,
      amountValue: amount,
      sendableAsset: sendableAsset,
    );
    final result = await _ionIdentityClient.wallets.makeTransfer(
      senderWallet,
      transfer,
      onVerifyIdentity,
    );

    return SendCoinsResult.fromJson(result);
  }
}
