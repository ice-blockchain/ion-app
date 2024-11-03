// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/posts_storage_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_replies_provider.g.dart';

@riverpod
class PostReplies extends _$PostReplies {
  @override
  Map<String, List<PostEntity>> build() {
    return {};
  }

  Future<void> fetchReplies({required String postId}) async {
    if (state[postId] != null) {
      return;
    }

    final posts = List.generate(Random().nextInt(10) + 1, (_) => generateFakePost())
      ..forEach(ref.read(nostrCacheProvider.notifier).cache);

    state = {...state, postId: posts};
  }
}

@riverpod
List<PostEntity> postRepliesSelector(Ref ref, {required String postId}) {
  return ref.watch(postRepliesProvider.select((state) => state[postId] ?? []));
}
