// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_relays.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coin_history_notifier_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CoinHistoryNotifier extends _$CoinHistoryNotifier {
  @override
  ({List<WalletAssetData> history, bool hasMore, List<EntitiesDataSource> dataSource})? build() {
    final dataSource = ref.watch(coinHistoryDataSourceProvider);
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    if (entitiesPagedData == null) {
      return null;
    }

    // final items = entitiesPagedData.data.items?.toList() ?? [];
    return (history: [], hasMore: entitiesPagedData.hasMore, dataSource: dataSource);
  }

  Future<void> loadMore() async {
    final dataSource = state?.dataSource;
    if (dataSource != null) {
      return ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
    }
  }

  Future<void> refresh() async {
    final dataSource = state?.dataSource;
    if (dataSource != null) {
      return ref.invalidate(entitiesPagedDataProvider(dataSource));
    }
  }
}

@riverpod
List<EntitiesDataSource> coinHistoryDataSource(Ref ref) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return [
    EntitiesDataSource(
      actionSource: const ActionSourceIndexers(),
      entityFilter: (entity) => entity is UserMetadataEntity,
      requestFilters: [
        RequestFilter(
          kinds: const [WalletAssetRelaysEntity.kind],
          tags: {
            '#p': [currentPubkey],
            'authors': [currentPubkey],
          },
          limit: 20,
        ),
      ],
    ),
  ];
}
