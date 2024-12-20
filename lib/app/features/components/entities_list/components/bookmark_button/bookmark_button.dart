// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarkButton extends ConsumerWidget {
  const BookmarkButton.post({required this.eventReference, super.key})
      : type = BookmarksSetType.posts;

  const BookmarkButton.story({required this.eventReference, super.key})
      : type = BookmarksSetType.stories;

  const BookmarkButton.video({required this.eventReference, super.key})
      : type = BookmarksSetType.videos;

  const BookmarkButton.article({required this.eventReference, super.key})
      : type = BookmarksSetType.articles;

  final EventReference? eventReference;
  final BookmarksSetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (eventReference == null) {
      return const SizedBox.shrink();
    }

    final isBookmarked = ref.watch(isBookmarkedProvider(eventReference!)).value ?? false;
    return IconButton(
      icon: SvgPicture.asset(
        isBookmarked ? Assets.svg.iconBookmarksOn : Assets.svg.iconBookmarks,
      ),
      onPressed: () => ref.read(bookmarksNotifierProvider.notifier).toggleBookmark(
            eventReference!,
            type: type,
          ),
    );
  }
}
