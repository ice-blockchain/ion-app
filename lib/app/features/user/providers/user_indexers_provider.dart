// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/user/providers/user_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_indexers_provider.g.dart';

@Riverpod(keepAlive: true)
class UserIndexers extends _$UserIndexers {
  @override
  Future<List<String>?> build() async {
    final userIdentity = await ref.watch(userIdentityProvider.future);
    if (userIdentity != null) {
      return userIdentity.ionConnectIndexerRelays;
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
class UserIndexerPicker extends _$UserIndexerPicker {
  @override
  int build() {
    ref.watch(userIndexersProvider);
    return 0;
  }

  Future<String> getNext() async {
    final indexers = await ref.read(userIndexersProvider.future);

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
