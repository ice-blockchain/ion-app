// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<UserMetadataEntity?> userMetadata(
  Ref ref,
  String pubkey, {
  bool network = true,
  bool cache = true,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(pubkey: pubkey, kind: UserMetadataEntity.kind),
      network: network,
      cache: cache,
    ).future,
  ) as UserMetadataEntity?;
}

@Riverpod(keepAlive: true)
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
