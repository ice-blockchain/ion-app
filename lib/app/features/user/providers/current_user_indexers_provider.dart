// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/user/providers/current_user_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_indexers_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserIndexers extends _$CurrentUserIndexers {
  @override
  Future<List<String>?> build() async {
    final userIdentity = await ref.watch(currentUserIdentityProvider.future);
    if (userIdentity != null) {
      return userIdentity.ionConnectIndexerRelays;
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
class IndexerPicker extends _$IndexerPicker {
  @override
  int build() {
    ref.watch(currentUserIndexersProvider);
    return 0;
  }

  Future<String> getNext() async {
    final indexers = await ref.read(currentUserIndexersProvider.future);

    if (indexers == null) {
      throw Exception("User's indexer list is not found");
    }

    if (indexers.isEmpty) {
      throw Exception("User's indexer list is empty");
    }

    final indexerUrl = indexers[state];
    state = (state + 1) % indexers.length;
    return indexerUrl;
  }
}
