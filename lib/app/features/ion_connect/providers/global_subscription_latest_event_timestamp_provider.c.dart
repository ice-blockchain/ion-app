// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_subscription_latest_event_timestamp_provider.c.g.dart';

@Riverpod(keepAlive: true)
class GlobalSubscriptionLatestEventTimestamp extends _$GlobalSubscriptionLatestEventTimestamp {
  @override
  int? build(EventType eventType) {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final value = ref
        .watch(
          userPreferencesServiceProvider(
            identityKeyName: currentUserMasterPubkey,
          ),
        )
        .getValue<int>(eventType.localKey);

    return value;
  }

  Future<void> update(int createdAt) async {
    final currentUserMasterPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    if (eventType == EventType.encrypted) {
      state = DateTime.now().microsecondsSinceEpoch - const Duration(days: 2).inMicroseconds;
    } else {
      if (state != null && state! >= createdAt) {
        return;
      }
      state = createdAt;
    }

    await ref
        .read(
          userPreferencesServiceProvider(
            identityKeyName: currentUserMasterPubkey,
          ),
        )
        .setValue(eventType.localKey, state!);

    return;
  }
}

enum EventType {
  regular,
  encrypted;

  String get localKey {
    return switch (this) {
      EventType.regular => 'global_subscription_latest_regular_event_timestamp_8',
      EventType.encrypted => 'global_subscription_latest_encrypted_event_timestamp_8',
    };
  }
}
