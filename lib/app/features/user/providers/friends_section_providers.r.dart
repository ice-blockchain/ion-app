// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_section_providers.r.g.dart';

const _friendsCountThreshold = 3;

@riverpod
bool hasEnoughFriends(Ref ref) {
  final followListState = ref.watch(currentUserFollowListProvider);
  final friendCount = followListState.value?.pubkeys.length ?? 0;
  return friendCount >= _friendsCountThreshold;
}

@riverpod
bool shouldShowFriendsLoader(Ref ref) {
  final followListState = ref.watch(currentUserFollowListProvider);
  final hasEnoughFriends = ref.watch(hasEnoughFriendsProvider);

  // Show loader if:
  // 1. Still loading the friends list, or
  // 2. Have enough friends but still loading metadata
  final stillLoadingFriends = followListState.isLoading;
  final stillLoadingMetadata = !ref.watch(isAnyFriendMetadataLoadedProvider);
  return stillLoadingFriends || (hasEnoughFriends && stillLoadingMetadata);
}

@riverpod
bool shouldShowFriendsList(Ref ref) {
  final hasEnoughFriends = ref.watch(hasEnoughFriendsProvider);
  final isAnyMetadataLoaded = ref.watch(isAnyFriendMetadataLoadedProvider);

  return hasEnoughFriends && isAnyMetadataLoaded;
}

@riverpod
bool shouldShowFriendsSection(Ref ref) {
  final shouldShowList = ref.watch(shouldShowFriendsListProvider);
  final shouldShowLoader = ref.watch(shouldShowFriendsLoaderProvider);

  return shouldShowList || shouldShowLoader;
}

@riverpod
bool isAnyFriendMetadataLoaded(Ref ref) {
  final pubkeys = ref.watch(currentUserFollowListProvider).valueOrNull?.pubkeys ?? [];
  if (pubkeys.isEmpty) return false;

  for (final pk in pubkeys.take(4)) {
    final metadata = ref.watch(userMetadataProvider(pk));
    if (metadata.hasValue) {
      return true;
    }
  }

  return false;
}
