// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.m.dart';
import 'package:ion/app/features/user/model/user_relays.f.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.r.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_filter_relays_provider.r.g.dart';

@riverpod
Future<Map<String, List<String>>> feedFilterRelays(Ref ref) async {
  final filter = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));

  // Use ref.read instead of ref.watch to avoid triggering data source provider which depends on this filter,
  // preventing unnecessary feed rerenders
  switch (filter) {
    case FeedFilter.forYou:
      return ref.read(feedForYouFilterRelaysProvider.future);
    case FeedFilter.following:
      return ref.read(feedFollowingFilterRelaysProvider.future);
  }
}

@riverpod
Future<Map<String, List<String>>> feedForYouFilterRelays(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final followListRelays = followList != null
      ? await ref.watch(userRelaysManagerProvider.notifier).fetch(followList.pubkeys)
      : <UserRelaysEntity>[];

  final userRelays = await ref.watch(currentUserRelaysProvider.future);
  if (userRelays == null) {
    throw UserRelaysNotFoundException();
  }

  final options = {
    for (final relays in [...followListRelays, userRelays]) relays.masterPubkey: relays.urls,
  };
  return findBestOptions(options);
}

@riverpod
Future<Map<String, List<String>>> feedFollowingFilterRelays(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final followListRelays = followList != null
      ? await ref.watch(userRelaysManagerProvider.notifier).fetch(followList.pubkeys)
      : <UserRelaysEntity>[];

  final options = {
    for (final relays in followListRelays) relays.masterPubkey: relays.urls,
  };
  return findBestOptions(options);
}
