// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_identity_provider.g.dart';

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

  Future<List<String>> assignUserRelays({required List<String> followees}) async {
    //TODO: Add identity.io patch ion-connect-relays here.
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      throw Exception('User is not authenticated');
    }

    final ionIdentityClient = await ref.watch(ionIdentityClientProvider.future);
    final response = await ionIdentityClient.users
        .setIONConnectRelays(userId: currentIdentityKeyName, followeeList: followees);
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
