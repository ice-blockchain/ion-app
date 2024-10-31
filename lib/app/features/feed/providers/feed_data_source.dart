// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_data_source.g.dart';

@riverpod
Future<Map<String, List<String>>> feedDataSource(Ref ref, {required FeedFilter filter}) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);
  if (followList == null) {
    throw FollowListNotFoundException();
  }

  switch (filter) {
    case FeedFilter.forYou:
      // final userRelays = ref.watch(currentUserRelaysProvider);
      return {};
    case FeedFilter.following:
      return {};
  }
}
