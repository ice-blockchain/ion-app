// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.r.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/providers/badges_notifier.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.r.g.dart';

@riverpod
Future<UserMetadataEntity?> userMetadata(
  Ref ref,
  String pubkey, {
  bool cache = true,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference:
          ReplaceableEventReference(masterPubkey: pubkey, kind: UserMetadataEntity.kind),
      // if profile badges data for pubkey is already cached - no need for the search
      search: ref.watch(cachedProfileBadgesDataProvider(pubkey)) == null
          ? ProfileBadgesSearchExtension(forKind: UserMetadataEntity.kind).toString()
          : null,
      cache: cache,
    ).future,
  ) as UserMetadataEntity?;
}

@riverpod
UserMetadataEntity? cachedUserMetadata(
  Ref ref,
  String pubkey,
) {
  return ref.watch(
    ionConnectSyncEntityProvider(
      eventReference:
          ReplaceableEventReference(masterPubkey: pubkey, kind: UserMetadataEntity.kind),
      // if profile badges data for pubkey is already cached - no need for the search
      search: ref.watch(cachedProfileBadgesDataProvider(pubkey)) == null
          ? ProfileBadgesSearchExtension(forKind: UserMetadataEntity.kind).toString()
          : null,
    ),
  ) as UserMetadataEntity?;
}

@riverpod
Future<UserMetadataEntity?> currentUserMetadata(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }

  try {
    return await ref.watch(userMetadataProvider(currentPubkey).future);
  } on UserRelaysNotFoundException catch (_) {
    return null;
  }
}

@riverpod
Future<bool> isUserDeleted(Ref ref, String pubkey) async {
  final userMetadata = await ref.watch(userMetadataProvider(pubkey).future);
  return userMetadata == null;
}
