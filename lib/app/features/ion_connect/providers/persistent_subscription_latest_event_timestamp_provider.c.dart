// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persistent_subscription_latest_event_timestamp_provider.c.g.dart';

@Riverpod(keepAlive: true)
class PersistentSubscriptionLatestEventTimestamp
    extends _$PersistentSubscriptionLatestEventTimestamp {
  static const _latestEventTimestampKey = 'persistent_subscription_latest_event_timestamp';

  @override
  int? build() {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    return ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .getValue<int>(_latestEventTimestampKey);
  }

  Future<void> update(int createdAt) async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    await ref
        .watch(userPreferencesServiceProvider(identityKeyName: currentUserMasterPubkey))
        .setValue(_latestEventTimestampKey, createdAt);
  }
}
