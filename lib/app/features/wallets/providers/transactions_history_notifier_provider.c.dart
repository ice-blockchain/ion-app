// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/core/model/paged.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_namespace_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_history_notifier_provider.c.g.dart';

typedef TransactionsHistoryState = ({
  List<WalletAssetEntity> transactions,
  bool hasMore,
  List<EntitiesDataSource> dataSource,
});

// TODO: Looks like it should be a repository part. Especially if the downloaded data will be stored in the DB.
@riverpod
class TransactionsHistoryNotifier extends _$TransactionsHistoryNotifier {
  @override
  TransactionsHistoryState? build({
    required CoinInWalletData coin,
    required int pageSize,
  }) {
    final dataSource = ref
        .watch(
          transactionsHistoryDataSourceProvider(coin: coin, pageSize: pageSize),
        )
        .value;
    if (dataSource == null) return null;

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final items = entitiesPagedData?.data.items?.whereType<WalletAssetEntity>().nonNulls.toList();

    if (entitiesPagedData == null) return null;

    if (entitiesPagedData.data is! PagedLoading && items != null) {
      final result = items.sortedBy((e) => e.createdAt);
      Logger.info('Transaction history loaded. Size of the history is ${result.length}.');
      return (
        transactions: result,
        hasMore: entitiesPagedData.hasMore,
        dataSource: dataSource,
      );
    }

    return null;
  }

  Future<void> loadMore() async {
    if (state?.dataSource case final List<EntitiesDataSource> dataSource) {
      return ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
    }
  }
}

@riverpod
Future<List<EntitiesDataSource>> transactionsHistoryDataSource(
  Ref ref, {
  required int pageSize,
  required CoinInWalletData coin,
}) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final walletAddresses = await ref.watch(connectedCryptoWalletsProvider.future).then(
        (wallets) => wallets
            .where(
              (w) =>
                  w.id == coin.walletId || (w.address != null && w.address == coin.walletAddress),
            )
            .map((w) => w.address)
            .nonNulls
            .toList(),
      );

  final generalTags = <String, List<Object?>>{
    '#network': [coin.coin.network.id],
    if (coin.coin.isNative)
      '#asset_class': ['Native']
    else
      '#asset_address': [coin.coin.contractAddress],
  };

  return [
    EntitiesDataSource(
      actionSource: const ActionSourceCurrentUser(),
      entityFilter: (entity) => entity is WalletAssetEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          limit: pageSize,
          tags: {
            '#p': [currentPubkey],
            ...generalTags,
          },
        ),
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          limit: pageSize,
          authors: [currentPubkey],
          tags: {
            ...generalTags,
          },
        ),
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          limit: pageSize,
          tags: {
            '#L': [LabelNamespaceTag.walletAddress().value],
            '#l': walletAddresses.map((wallet) => "loggedInUser'$wallet").toList(),
            ...generalTags,
          },
        ),
      ],
    ),
  ];
}
