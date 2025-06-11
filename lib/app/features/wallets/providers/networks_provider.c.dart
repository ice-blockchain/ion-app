// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_provider.c.g.dart';

@riverpod
Future<List<NetworkData>> networks(Ref ref) {
  return ref
      .watch(networksRepositoryProvider)
      .getAll()
      .then((networks) => networks.sortedBy((a) => a.displayName));
}

@riverpod
Future<NetworkData?> networkById(Ref ref, String id) {
  return ref.watch(networksRepositoryProvider).getById(id);
}
