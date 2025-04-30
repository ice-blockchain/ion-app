// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/push_notifications/data/models/push_subscription.c.dart';
import 'package:ion/app/services/device_id/device_id.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_subscription_provider.c.g.dart';

@riverpod
Future<PushSubscriptionEntity?> currentUserPushSubscription(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }

  final deviceId = await ref.watch(deviceIdServiceProvider).get();

  final eventReference = ReplaceableEventReference(
    pubkey: currentPubkey,
    kind: PushSubscriptionEntity.kind,
    dTag: deviceId,
  );

  return await ref.watch(ionConnectEntityProvider(eventReference: eventReference).future)
      as PushSubscriptionEntity?;
}
