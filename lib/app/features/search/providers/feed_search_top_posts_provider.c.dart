// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/fake_posts_generator.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_top_posts_provider.c.g.dart';

@riverpod
Future<List<ModifiablePostEntity>?> feedSearchTopPosts(
  Ref ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  ref.watch(feedSearchFilterProvider);
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  final posts =
      await Future.wait(List.generate(Random().nextInt(5) + 1, (_) => generateFakePost()));
  return posts..forEach(ref.read(ionConnectCacheProvider.notifier).cache);
}
