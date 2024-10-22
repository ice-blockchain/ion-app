// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_keystore_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_metadata_provider.g.dart';

@Riverpod(keepAlive: true)
Future<UserMetadata?> userMetadata(Ref ref, String pubkey) async {
  final userMetadata = ref.watch(nostrCacheProvider.select(cacheSelector<UserMetadata>(pubkey)));
  if (userMetadata != null) {
    return userMetadata;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [UserMetadata.kind], authors: [pubkey], limit: 1));
  final event = await ref.read(nostrNotifierProvider.notifier).requestOne(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );

  if (event != null) {
    final userMetadata = UserMetadata.fromEventMessage(event);
    ref.read(nostrCacheProvider.notifier).cache(userMetadata);
    return userMetadata;
  }

  return null;
}

@Riverpod(keepAlive: true)
Future<UserMetadata?> currentUserMetadata(Ref ref) async {
  final currentUserNostrKey = await ref.watch(currentUserNostrKeyStoreProvider.future);
  if (currentUserNostrKey == null) {
    return null;
  }
  return ref.watch(userMetadataProvider(currentUserNostrKey.publicKey).future);
}
