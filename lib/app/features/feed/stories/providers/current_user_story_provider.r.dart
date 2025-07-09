// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/stories/data/models/user_story.f.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_story_provider.r.g.dart';

@riverpod
UserStory? currentUserStory(Ref ref) {
  keepAliveWhenAuthenticated(ref);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  final dataSources = ref.watch(userStoriesDataSourceProvider(pubkey: currentPubkey, limit: 1));
  if (dataSources == null) {
    return null;
  }

  final story = ref
      .watch(entitiesPagedDataProvider(dataSources))
      ?.data
      .items
      ?.whereType<ModifiablePostEntity>()
      .firstOrNull;

  if (story == null) {
    return null;
  } else {
    return UserStory(pubkey: currentPubkey, story: story);
  }
}
