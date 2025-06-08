// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';

import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/features/user/data/models/user_relays.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/utils/algorithm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filter_relays_provider.c.g.dart';

@riverpod
Future<Map<String, List<String>>> feedSearchFilterRelays(Ref ref, FeedSearchSource source) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final followListRelays = followList != null
      ? await ref.read(userRelaysManagerProvider.notifier).fetch(followList.pubkeys)
      : <UserRelaysEntity>[];

  switch (source) {
    case FeedSearchSource.anyone:
      final userRelays = await ref.watch(currentUserRelaysProvider.future);
      if (userRelays == null) {
        throw UserRelaysNotFoundException();
      }

      final options = {
        for (final relays in [...followListRelays, userRelays]) relays.masterPubkey: relays.urls,
      };
      return findBestOptions(options);
    case FeedSearchSource.following:
      final options = {
        for (final relays in followListRelays) relays.masterPubkey: relays.urls,
      };
      return findBestOptions(options);
  }
}
