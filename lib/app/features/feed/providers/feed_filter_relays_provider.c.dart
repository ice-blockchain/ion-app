// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/user/model/user_relays.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_filter_relays_provider.c.g.dart';

@riverpod
Future<Map<String, List<String>>> feedFilterRelays(Ref ref, FeedFilter filter) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final followListRelays = followList != null
      ? await ref.read(userRelaysManagerProvider.notifier).fetch(
            followList.pubkeys,
            actionSource: const ActionSourceCurrentUser(),
          )
      : <UserRelaysEntity>[];

  switch (filter) {
    case FeedFilter.forYou:
      final userRelays = await ref.watch(currentUserRelayProvider.future);
      if (userRelays == null) {
        throw UserRelaysNotFoundException();
      }

      final options = {
        for (final relays in [...followListRelays, userRelays]) relays.masterPubkey: relays.urls,
      };
      return findBestOptions(options);
    case FeedFilter.following:
      final options = {
        for (final relays in followListRelays) relays.masterPubkey: relays.urls,
      };
      return findBestOptions(options);
  }
}
