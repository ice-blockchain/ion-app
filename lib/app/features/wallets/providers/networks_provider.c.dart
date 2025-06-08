// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/repository/networks_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_provider.c.g.dart';

@riverpod
Future<List<NetworkData>> networks(Ref ref) {
  return ref.watch(networksRepositoryProvider).getAll();
}

@riverpod
Future<NetworkData?> networkById(Ref ref, String id) {
  return ref.watch(networksRepositoryProvider).getById(id);
}
