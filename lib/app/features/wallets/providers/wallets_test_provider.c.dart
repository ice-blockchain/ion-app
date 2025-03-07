// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/wallets/model/wallet_relays.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_test_provider.c.g.dart';

@riverpod
class WalletsTest extends _$WalletsTest {
  @override
  void build() {
    final masterPubkey = ref.watch(currentPubkeySelectorProvider);
    final dataSource = ref.watch(walletsDataSourceProvider);
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));

    if (entitiesPagedData == null) {
      return;
    }

    final users = entitiesPagedData.data.items?.toList() ?? [];
    return;
  }

  // Future<void> loadMore() async {
  //   final dataSource = state?.dataSource;
  //   if (dataSource != null) {
  //     return ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities();
  //   }
  // }

  // Future<void> refresh() async {
  //   final dataSource = state?.dataSource;
  //   if (dataSource != null) {
  //     return ref.invalidate(entitiesPagedDataProvider(dataSource));
  //   }
  // }
}

@riverpod
List<EntitiesDataSource> walletsDataSource(Ref ref) {
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
          kinds: const [WalletRelaysEntity.kind],
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
