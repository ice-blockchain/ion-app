// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/providers/current_user_identity_provider.dart';
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
