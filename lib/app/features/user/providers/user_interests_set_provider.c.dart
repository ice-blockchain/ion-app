// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/enum.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/data/models/interest_set.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_interests_set_provider.c.g.dart';

@riverpod
Future<InterestSetEntity?> userInterestsSet(
  Ref ref,
  String pubkey, {
  required InterestSetType type,
  bool network = true,
  bool cache = true,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(
        pubkey: pubkey,
        kind: InterestSetEntity.kind,
        dTag: type.toShortString(),
      ),
      network: network,
      cache: cache,
    ).future,
  ) as InterestSetEntity?;
}

@riverpod
class CurrentUserInterestsSet extends _$CurrentUserInterestsSet {
  @override
  FutureOr<InterestSetEntity?> build(InterestSetType type) async {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return null;
    }

    return await ref.watch(userInterestsSetProvider(currentPubkey, type: type).future);
  }

  Future<void> set(List<String> hashtags) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final data = InterestSetData(type: type, hashtags: hashtags);
      final entity = await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntityData<InterestSetEntity>(data);
      return entity;
    });
  }
}
