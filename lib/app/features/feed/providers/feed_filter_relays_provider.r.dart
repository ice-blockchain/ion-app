// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.m.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/relays/optimal_user_relays_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_filter_relays_provider.r.g.dart';

/// Provides relay mapping based on the current feed filter.
@riverpod
Future<Map<String, List<String>>> feedFilterRelays(Ref ref) async {
  final filter = ref.watch(
    feedCurrentFilterProvider.select((state) => state.filter),
  );

  // Use ref.read to avoid unnecessary feed rerenders.
  switch (filter) {
    case FeedFilter.forYou:
      return ref.read(feedForYouFilterRelaysProvider.future);
    case FeedFilter.following:
      return ref.read(feedFollowingFilterRelaysProvider.future);
  }
}

/// Provides relay mapping for the "For You" feed filter.
@riverpod
Future<Map<String, List<String>>> feedForYouFilterRelays(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserPubkey == null) {
    throw const CurrentUserNotFoundException();
  }

  final masterPubkeys = [
    currentUserPubkey,
    if (followList != null) ...followList.masterPubkeys,
  ];

  final relayMapping = await ref.read(optimalUserRelaysProvider.notifier).fetch(
        masterPubkeys: masterPubkeys,
        strategy: OptimalRelaysStrategy.mostUsers,
      );

  return relayMapping;
}

/// Provides relay mapping for the "Following" feed filter.
@riverpod
Future<Map<String, List<String>>> feedFollowingFilterRelays(Ref ref) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);

  final masterPubkeys = [if (followList != null) ...followList.masterPubkeys];

  final relayMapping = await ref.read(optimalUserRelaysProvider.notifier).fetch(
        masterPubkeys: masterPubkeys,
        strategy: OptimalRelaysStrategy.mostUsers,
      );

  return relayMapping;
}
