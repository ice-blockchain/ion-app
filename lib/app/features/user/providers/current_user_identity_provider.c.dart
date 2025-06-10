// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_identity_provider.c.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserIdentity extends _$CurrentUserIdentity {
  @override
  Future<UserDetails?> build() async {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName != null) {
      final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
      return ionIdentityClient.users.currentUserDetails();
    }
    return null;
  }

  Future<List<String>> assignUserRelays({List<String>? followees}) async {
    final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
    final response =
        await ionIdentityClient.users.setIONConnectRelays(followeeList: followees ?? []);
    state = AsyncData(state.valueOrNull!.copyWith(ionConnectRelays: response.ionConnectRelays));
    return response.ionConnectRelays;
  }
}

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
