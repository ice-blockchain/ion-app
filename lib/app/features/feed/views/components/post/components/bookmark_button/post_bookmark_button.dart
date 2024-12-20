// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';

class PostBookmarkButton extends ConsumerWidget {
  const PostBookmarkButton({required this.id, super.key}) : type = BookmarksSetType.posts;

  const PostBookmarkButton.story({required this.id, super.key}) : type = BookmarksSetType.stories;

  const PostBookmarkButton.video({required this.id, super.key}) : type = BookmarksSetType.videos;

  final String? id;
  final BookmarksSetType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id == null || id!.isEmpty) {
      return const SizedBox.shrink();
    }

    final isBookmarked = ref.watch(isPostBookmarkedProvider(id!));

    return BookmarkButton(
      isBookmarked: isBookmarked,
      onBookmark: () {
        ref.read(bookmarksNotifierProvider.notifier).togglePostBookmark(id!, type: type);
      },
    );
  }
}
