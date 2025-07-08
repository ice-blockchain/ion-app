// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/users_relays_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_filter_relays_provider.r.g.dart';

@riverpod
Future<Map<String, List<String>>> feedSearchFilterRelays(
  Ref ref,
  FeedSearchSource source,
) async {
  final followList = await ref.watch(currentUserFollowListProvider.future);
  final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentUserPubkey == null) {
    throw const CurrentUserNotFoundException();
  }
  if (followList == null) {
    throw FollowListNotFoundException();
  }

  final masterPubkeys = <String>{
    if (source == FeedSearchSource.anyone) currentUserPubkey,
    ...followList.masterPubkeys,
  }.toList();

  final relayMapping =
      await ref.read(usersRelaysProviderProvider.notifier).fetch(masterPubkeys: masterPubkeys);

  return relayMapping;
}
