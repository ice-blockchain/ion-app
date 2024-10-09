// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/model/user_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_identity_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserIdentity?> currentUserIdentity(CurrentUserIdentityRef ref) async {
  final currentUserId = ref.watch(currentUserIdSelectorProvider);
  if (currentUserId.isNotEmpty) {
    //TODO: Add indentity.io `getUser` request here
    await Future<void>.delayed(const Duration(seconds: 1));
    return const UserIdentity(
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
    );
  }
  return null;
}
