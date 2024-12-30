// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/providers/create_post_notifier.c.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/current_user_story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';

class StoryList extends ConsumerWidget {
  const StoryList({
    required this.pubkeys,
    super.key,
  });

  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull ?? '';
    final filteredPubkeys = pubkeys.where((pubkey) => pubkey != currentUserPubkey).toList();

    ref.listenSuccess(createPostNotifierProvider(CreatePostOption.story), (next) {
      final dataSources = ref.read(feedStoriesDataSourceProvider) ?? [];
      if (dataSources.isNotEmpty) {
        ref.invalidate(entitiesPagedDataProvider(dataSources));
      }
    });

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
      sliver: SliverList.separated(
        itemCount: filteredPubkeys.length + 1,
        separatorBuilder: (_, __) => const StoryListSeparator(),
        itemBuilder: (_, index) {
          if (index == 0) {
            return CurrentUserStoryListItem(
              pubkey: currentUserPubkey,
              gradient: storyBorderGradients.first,
            );
          }

          final pubkey = filteredPubkeys[index - 1];
          return StoryListItem(
            pubkey: pubkey,
            gradient: storyBorderGradients[Random().nextInt(storyBorderGradients.length)],
          );
        },
      ),
    );
  }
}
