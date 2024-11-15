// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_data_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PostEntity?> postData(
  Ref ref, {
  required String postId,
  required String pubkey,
}) async {
  final post = ref.watch(
    nostrCacheProvider.select(cacheSelector<PostEntity>(PostEntity.cacheKeyBuilder(id: postId))),
  );
  if (post != null) {
    return post;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [PostEntity.kind], ids: [postId], limit: 1));
  return ref.read(nostrNotifierProvider.notifier).requestEntity<PostEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}
