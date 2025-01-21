// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/wallet_view_data.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_wallet_views_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<WalletViewData>> currentUserWalletViews(Ref ref) async {
  final identity = await ref.watch(ionIdentityClientProvider.future);

  final shortViews = await identity.wallets.getWalletViews();
  final viewsDetailsDTO = await Future.wait(
    shortViews.map((e) => identity.wallets.getWalletView(e.id)),
  );

  final result = <WalletViewData>[];
  for (final viewDTO in viewsDetailsDTO) {
    final coins = <CoinInWalletData>[];
    final symbolGroups = <String>{};

    // TODO: (1) Check the calculation of the total balance. Are the assets from aggregation is the same as coins?
    var totalViewBalanceUSD = 0.0;

    for (final coinInWalletDTO in viewDTO.coins) {
      final coinDTO = coinInWalletDTO.coin;
      final aggregationItem = viewDTO.aggregation[coinDTO.symbol];

      var coinAmount = 0.0;
      var coinBalanceUSD = 0.0;

      if (aggregationItem != null) {
        final asset = aggregationItem.wallets
            .firstWhereOrNull((wallet) => wallet.walletId == coinInWalletDTO.walletId)
            ?.asset;

        if (asset != null) {
          coinAmount = asset.balance;
          // TODO: (1) Check the result of formula with other services
          coinBalanceUSD = (coinAmount / pow(10, coinDTO.decimals)) * coinDTO.priceUSD;
        }
      }

      totalViewBalanceUSD += coinBalanceUSD;
      symbolGroups.add(coinDTO.symbolGroup);
      coins.add(
        CoinInWalletData(
          amount: coinAmount,
          balanceUSD: coinBalanceUSD,
          walletId: coinInWalletDTO.walletId,
          coin: CoinData.fromDTO(coinDTO),
        ),
      );
    }

    result.add(
      WalletViewData(
        coins: coins,
        id: viewDTO.id,
        name: viewDTO.name,
        symbolGroups: symbolGroups,
        createdAt: viewDTO.createdAt,
        updatedAt: viewDTO.updatedAt,
        usdBalance: totalViewBalanceUSD,
      ),
    );
  }

  return result;
}
