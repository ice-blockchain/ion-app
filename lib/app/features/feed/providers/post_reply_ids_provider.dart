// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ice/app/features/feed/providers/posts_storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_reply_ids_provider.g.dart';

@riverpod
class PostReplyIds extends _$PostReplyIds {
  @override
  Map<String, List<String>> build() {
    return {};
  }

  Future<void> fetchReplies({required String postId}) async {
    if (state[postId] != null) {
      return;
    }

    final posts = List.generate(Random().nextInt(10) + 1, (_) => generateFakePost());

    ref.read(postsStorageProvider.notifier).store(posts: posts);

    state = {...state, postId: posts.map((post) => post.id).toList()};
  }
}

@riverpod
List<String> postReplyIdsSelector(PostReplyIdsSelectorRef ref, {required String postId}) {
  return ref.watch(postReplyIdsProvider.select((state) => state[postId] ?? []));
}
