// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/wallet_flag_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/providers/connected_crypto_wallets_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_history_notifier_provider.c.g.dart';

@Riverpod(keepAlive: true)
class TransactionsHistoryNotifier extends _$TransactionsHistoryNotifier {
  final _allItems = <WalletAssetEntity>{};

  @override
  List<WalletAssetEntity>? build() {
    final dataSource = ref.watch(transactionsHistoryDataSourceProvider).value;
    if (dataSource == null) return [];

    final notifier = ref.read(entitiesPagedDataProvider(dataSource).notifier);

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final items =
        entitiesPagedData?.data.items?.whereType<WalletAssetEntity>().nonNulls.toList() ?? [];
    _allItems.addAll(items);

    if (entitiesPagedData == null) return null;

    if (!entitiesPagedData.hasMore) {
      return _allItems.sortedBy((e) => e.createdAt);
    }

    notifier.fetchEntities();
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
            '#L': const [WalletFlagTag.tagValue],
            '#l': walletAddresses.map((wallet) => "loggedInUser'$wallet").toList(),
          },
        ),
      ],
    ),
  ];
}

// @riverpod
// class Replies extends _$Replies {
//   @override
//   EntitiesPagedDataState? build(EventReference eventReference) {
//     final dataSource = ref.watch(repliesDataSourceProvider(eventReference: eventReference));
//     final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

//     final subscription = ref
//         .watch(createPostNotifierStreamProvider)
//         .where((entity) => _isReply(entity, eventReference))
//         .distinct()
//         .listen(_handleReply);
//     ref.onDispose(subscription.cancel);

//     return entitiesPagedData;
//   }

//   bool _isReply(IonConnectEntity entity, EventReference parentEventReference) {
//     return entity is ModifiablePostEntity &&
//         entity.data.parentEvent?.eventReference == parentEventReference;
//   }

//   void _handleReply(IonConnectEntity entity) {
//     final items = state?.data.items ?? {};
//     state = state?.copyWith.data(items: {entity, ...items});
//   }

//   Future<void> loadMore(EventReference eventReference) async {
//     final dataSource = ref.read(repliesDataSourceProvider(eventReference: eventReference));
//     await ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
//   }
// }
