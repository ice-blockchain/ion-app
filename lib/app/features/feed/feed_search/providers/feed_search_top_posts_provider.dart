// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/feed_search/providers/feed_search_filters_provider.dart';
import 'package:ion/app/features/feed/providers/posts_storage_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_top_posts_provider.g.dart';

@riverpod
Future<List<String>?> feedSearchTopPosts(
  FeedSearchTopPostsRef ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  ref.watch(feedSearchFilterProvider);
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  final posts = List.generate(Random().nextInt(5) + 1, (_) => generateFakePost())
    ..forEach(ref.read(nostrCacheProvider.notifier).cache);

  return posts.map((post) => post.id).toList();
}
