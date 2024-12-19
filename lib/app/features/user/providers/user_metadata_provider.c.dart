// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<UserMetadataEntity?> userMetadata(
  Ref ref,
  String pubkey, {
  bool cacheOnly = false,
}) async {
  final userMetadata = ref.watch(
    nostrCacheProvider.select(
      cacheSelector<UserMetadataEntity>(UserMetadataEntity.cacheKeyBuilder(pubkey: pubkey)),
    ),
  );

  if (userMetadata != null || cacheOnly) {
    return userMetadata;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserMetadataEntity.kind], authors: [pubkey], limit: 1));
  return ref.read(nostrNotifierProvider.notifier).requestEntity<UserMetadataEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
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
