// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_data_source_provider.g.dart';

@riverpod
Future<Map<String, List<String>>> feedDataSource(Ref ref, FeedFilter filter) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);
  if (followList == null) {
    throw FollowListNotFoundException();
  }

  final followListRelays = await ref
      .read(userRelaysManagerProvider.notifier)
      .fetch(followList.pubkeys, actionSource: const ActionSourceCurrentUser());

  switch (filter) {
    case FeedFilter.forYou:
      final userRelays = await ref.read(userRelaysManagerProvider.notifier).fetchForCurrentUser();
      if (userRelays == null) {
        throw UserRelaysNotFoundException();
      }

      final options = {
        for (final relays in [...followListRelays, userRelays]) relays.pubkey: relays.urls,
      };
      return findBestOptions(options);
    case FeedFilter.following:
      final options = {
        for (final relays in followListRelays) relays.pubkey: relays.urls,
      };
      return findBestOptions(options);
  }
}
