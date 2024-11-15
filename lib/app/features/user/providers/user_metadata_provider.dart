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
Future<UserMetadataEntity?> userMetadata(Ref ref, String pubkey) async {
  final userMetadata = ref.watch(
    nostrCacheProvider.select(
      cacheSelector<UserMetadataEntity>(UserMetadataEntity.cacheKeyBuilder(pubkey: pubkey)),
    ),
  );
  if (userMetadata != null) {
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
  final currentUserNostrKey = await ref.watch(currentUserNostrKeyStoreProvider.future);
  if (currentUserNostrKey == null) {
    return null;
  }
  return ref.watch(userMetadataProvider(currentUserNostrKey.publicKey).future);
}
