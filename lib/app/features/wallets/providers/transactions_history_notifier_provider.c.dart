// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_namespace_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_history_notifier_provider.c.g.dart';

@Riverpod(keepAlive: true)
class TransactionsHistoryNotifier extends _$TransactionsHistoryNotifier {
  final _allItems = <WalletAssetEntity>{};

  @override
  List<WalletAssetEntity>? build() {
    final dataSource = ref.watch(transactionsHistoryDataSourceProvider).value;
    if (dataSource == null) return null;

    final notifier = ref.read(entitiesPagedDataProvider(dataSource).notifier);

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final items =
        entitiesPagedData?.data.items?.whereType<WalletAssetEntity>().nonNulls.toList() ?? [];
    _allItems.addAll(items);

    if (entitiesPagedData == null) return null;

    if (!entitiesPagedData.hasMore) {
      final result = _allItems.sortedBy((e) => e.createdAt);
      Logger.info('Transaction history loaded. Size of the history is ${result.length}.');
      return result;
    }

    // Load the next page
    Future.microtask(() {
      unawaited(
        notifier.fetchEntities(),
      );
    });

    return null;
  }
}

@riverpod
Future<List<EntitiesDataSource>> transactionsHistoryDataSource(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final walletAddresses = await ref.watch(connectedCryptoWalletsProvider.future);

  return [
    EntitiesDataSource(
      actionSource: const ActionSourceCurrentUser(),
      entityFilter: (entity) => entity is WalletAssetEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          tags: {
            '#p': [currentPubkey],
          },
        ),
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          tags: {
            'authors': [currentPubkey],
          },
        ),
        RequestFilter(
          kinds: const [WalletAssetEntity.kind],
          tags: {
            '#L': [LabelNamespaceTag.walletAddress().value],
            '#l': walletAddresses.map((wallet) => "loggedInUser'$wallet").toList(),
          },
        ),
      ],
    ),
  ];
}
