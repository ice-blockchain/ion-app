// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/storage/user_preferences_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_subscription_latest_event_timestamp_provider.c.g.dart';

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

class GlobalSubscriptionLatestEventTimestampService {
  GlobalSubscriptionLatestEventTimestampService({
    required this.userPreferenceService,
  });

  final UserPreferencesService userPreferenceService;
  int? get(EventType eventType) {
    final value = userPreferenceService.getValue<int>(eventType.localKey);

    return value;
  }

  Future<void> update(int createdAt, EventType eventType) async {
    int? latestEventTimestamp;
    if (eventType == EventType.encrypted) {
      latestEventTimestamp =
          DateTime.now().microsecondsSinceEpoch - const Duration(days: 2).inMicroseconds;
    } else {
      final existingValue = get(eventType);
      if (existingValue != null && existingValue >= createdAt) {
        return;
      }
      latestEventTimestamp = createdAt;
    }

    await userPreferenceService.setValue(eventType.localKey, latestEventTimestamp);

    return;
  }
}

@riverpod
GlobalSubscriptionLatestEventTimestampService? globalSubscriptionLatestEventTimestampService(
  Ref ref,
) {
  final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (identityKeyName == null) {
    return null;
  }

  return GlobalSubscriptionLatestEventTimestampService(
    userPreferenceService:
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName)),
  );
}
