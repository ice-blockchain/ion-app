// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/mock.dart';

class StoryList extends ConsumerWidget {
  const StoryList({
    required this.pubkeys,
    super.key,
  });

  final List<String> pubkeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider) ?? '';

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
      sliver: SliverList.separated(
        itemCount: pubkeys.length + 1,
        separatorBuilder: (_, __) => const StoryListSeparator(),
        itemBuilder: (_, index) {
          if (index == 0) {
            return StoryListItem(
              pubkey: currentUserPubkey,
              gradient: storyBorderGradients.first,
            );
          }

          final pubkey = pubkeys[index - 1];

          final item = StoryListItem(
            pubkey: pubkey,
            gradient: storyBorderGradients[Random().nextInt(storyBorderGradients.length)],
          );

          return item;
        },
      ),
    );
  }
}
