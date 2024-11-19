// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/model/user_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'current_user_identity_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserIdentity extends _$CurrentUserIdentity {
  @override
  Future<UserIdentity?> build() async {
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (currentIdentityKeyName != null) {
      //TODO: Add indentity.io `getUser` request here
      await Future<void>.delayed(const Duration(seconds: 1));
      // using local storage to simulate BE response, remove when real request is impl
      final prefs = await SharedPreferences.getInstance();
      final relaysSet = prefs.getBool('relays_set_$currentIdentityKeyName') ?? false;
      return UserIdentity(
        ionConnectIndexerRelays: [
          'wss://relay.damus.io',
          'wss://relay.damus.io',
          'wss://relay.damus.io',
        ],
        ionConnectRelays: relaysSet
            ? [
                'wss://relay.damus.io',
                'wss://relay.damus.io',
                'wss://relay.damus.io',
              ]
            : [],
        masterPubkey: 'some_key',
      );
    }
    return null;
  }

  Future<List<String>> assignUserRelays({required List<String> followees}) async {
    //TODO: Add identity.io patch ion-connect-relays here.
    final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);

    if (currentIdentityKeyName == null) {
      throw Exception('User is not authenticated');
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));
    // using local storage to simulate BE response, remove when real request is impl
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('relays_set_$currentIdentityKeyName', true);
    state = const AsyncData(
      UserIdentity(
        ionConnectIndexerRelays: [
          'wss://relay.damus.io',
          'wss://relay.damus.io',
          'wss://relay.damus.io',
        ],
        ionConnectRelays: [
          'wss://relay.damus.io',
          'wss://relay.damus.io',
          'wss://relay.damus.io',
        ],
        masterPubkey: 'some_key',
      ),
    );
    return [
      'wss://relay.damus.io',
      'wss://relay.damus.io',
      'wss://relay.damus.io',
    ];
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
